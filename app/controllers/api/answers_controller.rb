class Api::AnswersController < Api::BaseController
  def show
    course_id = params[:course_id]
    
    answers = Answer.where(course_id: course_id)
    
    # 質問ごとに回答をグループ化
    answers_by_questions = answers.group_by(&:question_id).map do |question_id, question_answers|
      {
        questionId: question_id,
        contents: question_answers.map(&:content)
      }
    end
    
    response_data = {
      courseId: course_id,
      answersByQuestions: answers_by_questions
    }
    
    render_json_success(response_data)
  end
  
  def create
    form_token = params[:formToken]
    course_id = params[:courseId]
    answers_data = params[:answers]
    
    ActiveRecord::Base.transaction do
      answers_data.each do |answer_params|
        Answer.create!(
          form_token: form_token,
          course_id: course_id,
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
