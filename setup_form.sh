#!/bin/bash

# Course Review Form Setup Script
# 昨年度のフォーム設計に基づいて、フォーム、質問、オプションを一括登録するスクリプト

#BASE_URL="https://<Your API Base URL>/api"を前もって設定しておく。
YEAR=2025

echo "=== Course Review Form Setup Script ==="
echo "Base URL: $BASE_URL"
echo "Year: $YEAR"
echo ""

# 色付きの出力用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_section() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_step() {
    echo -e "${YELLOW}Step: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# エラーハンドリング関数
check_response() {
    local response="$1"
    local step_name="$2"
    
    if [[ -z "$response" ]]; then
        print_error "$step_name failed: Empty response"
        return 1
    fi
    
    if echo "$response" | grep -q '"error"'; then
        print_error "$step_name failed: $(echo "$response" | grep -o '"error":"[^"]*"' | cut -d'"' -f4)"
        return 1
    fi
    
    print_success "$step_name completed"
    return 0
}

# =============================================================================
# 1. フォーム作成
# =============================================================================
print_section "Creating Form"

print_step "Creating form for year $YEAR"
FORM_RESPONSE=$(curl -s -X POST "$BASE_URL/form" \
  -H "Content-Type: application/json" \
  -d '{"year": '$YEAR'}')

# フォームが既に存在する場合は取得
if echo "$FORM_RESPONSE" | grep -q "already been taken"; then
    print_step "Form already exists, fetching existing form..."
    FORM_RESPONSE=$(curl -s "$BASE_URL/form/$YEAR?lang=ja")
fi

if ! check_response "$FORM_RESPONSE" "Form creation"; then
    echo "Response: $FORM_RESPONSE"
    exit 1
fi

FORM_ID=$(echo "$FORM_RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
echo "Form ID: $FORM_ID"
echo ""

if [[ -z "$FORM_ID" ]]; then
    print_error "Failed to extract Form ID"
    exit 1
fi

# =============================================================================
# 2. 質問とオプション作成（昨年度の設計に基づく）
# =============================================================================
print_section "Creating Questions and Options"

print_step "Creating Question 1: 評価項目 (Assessment Materials)"
QUESTION1_RESPONSE=$(curl -s -X POST "$BASE_URL/question" \
  -H "Content-Type: application/json" \
  -d '[
    {
      "textJa": "評価項目",
      "textEn": "From which assessment material(s) evaluations were done?",
      "descriptionJa": "",
      "descriptionEn": "",
      "placeholderJa": "",
      "placeholderEn": "",
      "formId": "'$FORM_ID'",
      "type": "checkbox",
      "require": false,
      "filterType": null,
      "order": 1,
      "options": [
        {
          "textJa": "小テスト",
          "textEn": "Quizes",
          "order": 1,
          "filterType": null
        },
        {
          "textJa": "中間レポート",
          "textEn": "Midterm Report(s)",
          "order": 2,
          "filterType": 5
        },
        {
          "textJa": "期末レポート",
          "textEn": "Term Report(s)",
          "order": 3,
          "filterType": 5
        },
        {
          "textJa": "中間試験",
          "textEn": "Midterm Exam",
          "order": 4,
          "filterType": 6
        },
        {
          "textJa": "期末試験",
          "textEn": "Term Exam",
          "order": 5,
          "filterType": 6
        },
        {
          "textJa": "出席点(リアクションペーパーも含む)",
          "textEn": "Attendance Rate (or Reaction Papers)",
          "order": 6,
          "filterType": null
        },
        {
          "textJa": "その他",
          "textEn": "others",
          "order": 7,
          "filterType": 7
        }
      ]
    }
  ]')

if ! check_response "$QUESTION1_RESPONSE" "Question 1 creation"; then
    echo "Response: $QUESTION1_RESPONSE"
    exit 1
fi

print_step "Creating Question 2: 授業の分かりやすさ (Course Understanding)"
QUESTION2_RESPONSE=$(curl -s -X POST "$BASE_URL/question" \
  -H "Content-Type: application/json" \
  -d '[
    {
      "textJa": "授業は分かりやすかったですか？",
      "textEn": "How easy was this course to understand?",
      "descriptionJa": "",
      "descriptionEn": "",
      "placeholderJa": "",
      "placeholderEn": "",
      "formId": "'$FORM_ID'",
      "type": "radio",
      "require": true,
      "filterType": null,
      "order": 2,
      "options": [
        {
          "textJa": "かなり分かりやすかった",
          "textEn": "Very Easy",
          "order": 1,
          "filterType": null
        },
        {
          "textJa": "比較的分かりやすかった",
          "textEn": "Easy",
          "order": 2,
          "filterType": null
        },
        {
          "textJa": "普通",
          "textEn": "so-so",
          "order": 3,
          "filterType": null
        },
        {
          "textJa": "比較的分かりづらかった",
          "textEn": "Difficult",
          "order": 4,
          "filterType": null
        },
        {
          "textJa": "分かりづらかった",
          "textEn": "Very Difficult",
          "order": 5,
          "filterType": null
        }
      ]
    }
  ]')

if ! check_response "$QUESTION2_RESPONSE" "Question 2 creation"; then
    echo "Response: $QUESTION2_RESPONSE"
    exit 1
fi

print_step "Creating Question 3: 講義全体の評価 (Overall Course Evaluation)"
QUESTION3_RESPONSE=$(curl -s -X POST "$BASE_URL/question" \
  -H "Content-Type: application/json" \
  -d '[
    {
      "textJa": "講義全体の評価は？",
      "textEn": "How was your evaluation of this course?",
      "descriptionJa": "",
      "descriptionEn": "",
      "placeholderJa": "",
      "placeholderEn": "",
      "formId": "'$FORM_ID'",
      "type": "radio",
      "require": true,
      "filterType": null,
      "order": 3,
      "options": [
        {
          "textJa": "大変良かった",
          "textEn": "Very Good",
          "order": 1,
          "filterType": null
        },
        {
          "textJa": "比較的良かった",
          "textEn": "Good",
          "order": 2,
          "filterType": null
        },
        {
          "textJa": "普通",
          "textEn": "so-so",
          "order": 3,
          "filterType": null
        },
        {
          "textJa": "あまり良くなかった",
          "textEn": "Bad",
          "order": 4,
          "filterType": null
        },
        {
          "textJa": "ひどかった",
          "textEn": "Very Bad",
          "order": 5,
          "filterType": null
        }
      ]
    }
  ]')

if ! check_response "$QUESTION3_RESPONSE" "Question 3 creation"; then
    echo "Response: $QUESTION3_RESPONSE"
    exit 1
fi

print_step "Creating Question 4: 点数 (Grade)"
QUESTION4_RESPONSE=$(curl -s -X POST "$BASE_URL/question" \
  -H "Content-Type: application/json" \
  -d '[
    {
      "textJa": "点数は？",
      "textEn": "How much was your grade?",
      "descriptionJa": "",
      "descriptionEn": "",
      "placeholderJa": "",
      "placeholderEn": "",
      "formId": "'$FORM_ID'",
      "type": "radio",
      "require": false,
      "filterType": null,
      "order": 4,
      "options": [
        {
          "textJa": "90点台 または 100点",
          "textEn": "90-100",
          "order": 1,
          "filterType": null
        },
        {
          "textJa": "80点台",
          "textEn": "80-89",
          "order": 2,
          "filterType": null
        },
        {
          "textJa": "70点台",
          "textEn": "70-79",
          "order": 3,
          "filterType": null
        },
        {
          "textJa": "60点台",
          "textEn": "60-69",
          "order": 4,
          "filterType": null
        },
        {
          "textJa": "合格(合否科目の場合)",
          "textEn": "Passed (if this is a pass / failed subject)",
          "order": 5,
          "filterType": null
        },
        {
          "textJa": "落第した",
          "textEn": "I failed to get the credit.",
          "order": 6,
          "filterType": null
        }
      ]
    }
  ]')

if ! check_response "$QUESTION4_RESPONSE" "Question 4 creation"; then
    echo "Response: $QUESTION4_RESPONSE"
    exit 1
fi

print_step "Creating Question 5: レポート情報 (Report Information)"
QUESTION5_RESPONSE=$(curl -s -X POST "$BASE_URL/question" \
  -H "Content-Type: application/json" \
  -d '[
    {
      "textJa": "レポートの情報を教えてください。",
      "textEn": "What are the details of the report?",
      "descriptionJa": "例：内容や分量の目安、何回あったか",
      "descriptionEn": "e.g. content, quantity, how many times it happened",
      "placeholderJa": "回答を入力...",
      "placeholderEn": "Input your answer ...",
      "formId": "'$FORM_ID'",
      "type": "text",
      "require": false,
      "filterType": 5,
      "order": 5,
      "options": []
    }
  ]')

if ! check_response "$QUESTION5_RESPONSE" "Question 5 creation"; then
    echo "Response: $QUESTION5_RESPONSE"
    exit 1
fi

print_step "Creating Question 6: 試験情報 (Exam Information)"
QUESTION6_RESPONSE=$(curl -s -X POST "$BASE_URL/question" \
  -H "Content-Type: application/json" \
  -d '[
    {
      "textJa": "試験についての情報を教えてください。",
      "textEn": "What are the details of the exam?",
      "descriptionJa": "例：試験の難易度や内容、対策方法など",
      "descriptionEn": "e.g. difficulty, content, how to prepare for it",
      "placeholderJa": "回答を入力...",
      "placeholderEn": "Input your answer ...",
      "formId": "'$FORM_ID'",
      "type": "text",
      "require": false,
      "filterType": 6,
      "order": 6,
      "options": []
    }
  ]')

if ! check_response "$QUESTION6_RESPONSE" "Question 6 creation"; then
    echo "Response: $QUESTION6_RESPONSE"
    exit 1
fi

print_step "Creating Question 7: その他の評価項目 (Other Assessment Materials)"
QUESTION7_RESPONSE=$(curl -s -X POST "$BASE_URL/question" \
  -H "Content-Type: application/json" \
  -d '[
    {
      "textJa": "その他の評価項目についての情報を教えてください。",
      "textEn": "What are the details of the other assessment material?",
      "descriptionJa": "例：プレゼンなど",
      "descriptionEn": "e.g. presentation etc.",
      "placeholderJa": "回答を入力...",
      "placeholderEn": "Input your answer ...",
      "formId": "'$FORM_ID'",
      "type": "text",
      "require": false,
      "filterType": 7,
      "order": 7,
      "options": []
    }
  ]')

if ! check_response "$QUESTION7_RESPONSE" "Question 7 creation"; then
    echo "Response: $QUESTION7_RESPONSE"
    exit 1
fi

print_step "Creating Question 8: 授業コメント (Course Comments)"
QUESTION8_RESPONSE=$(curl -s -X POST "$BASE_URL/question" \
  -H "Content-Type: application/json" \
  -d '[
    {
      "textJa": "レポートや試験以外の、授業についてのコメントをご自由にお書きください。",
      "textEn": "Please feel free to write any comments about the course, other than reports and exams.",
      "descriptionJa": "例：説明が分かりやすい　教科書の有無　試験さえ出席すればOK",
      "descriptionEn": "e.g. easy explanations, need for textbooks, all you have to do is attend the exam",
      "placeholderJa": "回答を入力...",
      "placeholderEn": "Input your answer ...",
      "formId": "'$FORM_ID'",
      "type": "text",
      "require": false,
      "filterType": null,
      "order": 8,
      "options": []
    }
  ]')

if ! check_response "$QUESTION8_RESPONSE" "Question 8 creation"; then
    echo "Response: $QUESTION8_RESPONSE"
    exit 1
fi

# =============================================================================
# 3. セットアップ完了の確認
# =============================================================================
print_section "Setup Verification"

print_step "Fetching created form to verify setup"
VERIFY_RESPONSE=$(curl -s "$BASE_URL/form/$YEAR?lang=ja")

if ! check_response "$VERIFY_RESPONSE" "Form verification"; then
    echo "Response: $VERIFY_RESPONSE"
    exit 1
fi

# 質問数を確認
QUESTION_COUNT=$(echo "$VERIFY_RESPONSE" | python3 -c "import sys, json; data=json.load(sys.stdin); print(len(data['questions']))" 2>/dev/null || echo "0")
echo "Created questions count: $QUESTION_COUNT"

if [ "$QUESTION_COUNT" -ge 8 ]; then
    print_success "Form setup completed successfully!"
    echo ""
    echo "Form ID: $FORM_ID"
    echo "Year: $YEAR"
    echo "Questions created: $QUESTION_COUNT"
    echo ""
    echo "You can now test the form with:"
    echo "curl '$BASE_URL/form/$YEAR?lang=ja'"
    echo "curl '$BASE_URL/form/$YEAR?lang=en'"
else
    print_error "Form setup incomplete. Expected 8+ questions, got $QUESTION_COUNT"
    exit 1
fi

echo ""
print_section "Setup Complete"
echo -e "${GREEN}✓ Form setup completed successfully!${NC}"
echo "Form is ready for use with the Course Review system."
