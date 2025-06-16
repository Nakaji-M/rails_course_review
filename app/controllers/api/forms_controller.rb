class Api::FormsController < Api::BaseController
  def show
    year = params[:year].to_i
    lang = params[:lang] || 'ja'
    
    form = Form.find_by(year: year)
    return render_json_error('Form not found', status: :not_found) unless form
    
    questions = form.questions.includes(:options).order(:order)
    
    response_data = {
      id: form.id,
      lang: lang,
      year: form.year,
      questions: questions.map do |question|
        {
          id: question.id,
          require: question.require,
          type: question.type,
          text: lang == 'ja' ? question.text_ja : question.text_en,
          description: lang == 'ja' ? question.description_ja : question.description_en,
          placeholder: lang == 'ja' ? question.placeholder_ja : question.placeholder_en,
          filterType: question.filter_type,
          options: question.options.order(:order).map do |option|
            {
              id: option.id,
              text: lang == 'ja' ? option.text_ja : option.text_en,
              questionFilterType: option.filter_type
            }
          end
        }
      end
    }
    
    render_json_success(response_data)
  end
  
  def create
    year = params[:year]
    
    form = Form.create!(year: year)
    
    render_json_success({ id: form.id, year: form.year }, status: :created)
  rescue ActiveRecord::RecordInvalid => e
    render_json_error(e.message)
  end
end
