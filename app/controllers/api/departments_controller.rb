class Api::DepartmentsController < Api::BaseController
  def index
    lang = params[:lang] || 'ja'
    
    departments = Department.all.order(:id)
    
    response_data = departments.map do |department|
      {
        id: department.id.to_i, # 数値として返す
        name: department.name
      }
    end
    
    render_json_success(response_data)
  end
  
  def create
    departments_data = params[:_json] || [params]
    
    ActiveRecord::Base.transaction do
      departments_data.each do |department_params|
        Department.create!(
          id: department_params[:id].to_s, # 文字列として保存
          name: department_params[:nameJa]
        )
      end
    end
    
    render_json_success({ message: 'Departments created successfully' }, status: :created)
  rescue ActiveRecord::RecordInvalid => e
    render_json_error(e.message)
  end
end
