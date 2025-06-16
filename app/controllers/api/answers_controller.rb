class Api::AnswersController < Api::BaseController
  def show
    course_id = params[:course_id]
    
    # course_idからcourseを取得し、対応するocw_idを取得
    course = Course.find_by(id: course_id)
    if course
      ocw_id = course.ocw_id
      answers = Answer.where(ocw_id: ocw_id)
    else
      # 対応するコースが見つからない場合は空の結果を返す
      answers = Answer.none
      ocw_id = nil
    end
    
    # 質問ごとに回答をグループ化
    answers_by_questions = answers.group_by(&:question_id).map do |question_id, question_answers|
      {
        questionId: question_id,
        contents: question_answers.map(&:content)
      }
    end
    
    response_data = {
      courseId: course_id,
      ocwId: ocw_id,
      answersByQuestions: answers_by_questions
    }
    
    render_json_success(response_data)
  end
  
  def create
    form_token = params[:formToken] || params[:appToken]
    ocw_id = params[:ocwId]
    answers_data = params[:answers]

    # 必須パラメータのチェック
    unless form_token && ocw_id && answers_data
      render_json_error("Missing required parameters", status: :bad_request) and return
    end

    ActiveRecord::Base.transaction do
      answers_data.each do |answer_params|
        content = answer_params[:content]
        question_id = answer_params[:questionId]
        
        # questionの存在確認
        question = Question.find_by(id: question_id)
        unless question
          raise ActiveRecord::RecordNotFound, "Question not found: #{question_id}"
        end

        # 既存のanswerを検索（更新 or 作成）
        answer = Answer.find_by(
          form_token: form_token,
          ocw_id: ocw_id,
          question_id: question.id
        )

        if answer.present?
          # 既存のanswerを更新
          answer.update!(content: content)
        else
          # 新しいanswerを作成
          Answer.create!(
            form_token: form_token,
            ocw_id: ocw_id,
            question_id: question.id,
            content: content
          )
        end
      end
    end
    
    render_json_success({ message: 'Answers created successfully' }, status: :created)
  rescue ActiveRecord::RecordInvalid => e
    render_json_error(e.message, status: :unprocessable_entity)
  rescue ActiveRecord::RecordNotFound => e
    render_json_error(e.message, status: :not_found)
  end
end
