class Api::QuestionsController < Api::BaseController
  def create
    questions_data = params[:_json] || [params]
    
    ActiveRecord::Base.transaction do
      questions_data.each do |question_params|
        question = Question.create!(
          text_ja: question_params[:textJa],
          text_en: question_params[:textEn],
          description_ja: question_params[:descriptionJa],
          description_en: question_params[:descriptionEn],
          placeholder_ja: question_params[:placeholderJa],
          placeholder_en: question_params[:placeholderEn],
          form_id: question_params[:formId],
          type: question_params[:type],
          require: question_params[:require],
          filter_type: question_params[:filterType],
          order: question_params[:order]
        )
        
        # オプションの作成
        if question_params[:options].present?
          question_params[:options].each do |option_params|
            Option.create!(
              question_id: question.id,
              text_ja: option_params[:textJa],
              text_en: option_params[:textEn],
              order: option_params[:order],
              filter_type: option_params[:filterType]
            )
          end
        end
      end
    end
    
    render_json_success({ message: 'Questions created successfully' }, status: :created)
  rescue ActiveRecord::RecordInvalid => e
    render_json_error(e.message)
  end
end
