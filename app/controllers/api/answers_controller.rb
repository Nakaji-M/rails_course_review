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
    form_token = params[:formToken]
    course_id = params[:courseId]
    answers_data = params[:answers]
    
    # course_idからocw_idを取得
    if course_id.length == 36
      # UUID形式（36文字）の場合はcourseテーブルから対応するocw_idを取得
      course = Course.find_by(id: course_id)
      if course
        ocw_id = course.ocw_id
      else
        return render_json_error('Course not found', status: :not_found)
      end
    elsif course_id.match?(/\A\d+\z/)
      # 数値の場合はそのままocw_idとして使用
      ocw_id = course_id.to_i
    else
      return render_json_error('Invalid course_id format', status: :bad_request)
    end
    
    ActiveRecord::Base.transaction do
      answers_data.each do |answer_params|
        Answer.create!(
          form_token: form_token,
          ocw_id: ocw_id,
          question_id: answer_params[:questionId],
          content: answer_params[:content]
        )
      end
    end
    
    render_json_success({ message: 'Answers created successfully' }, status: :created)
  rescue ActiveRecord::RecordInvalid => e
    render_json_error(e.message)
  end
end
