class Api::CoursesController < Api::BaseController
  def index
    year = params[:year].to_i
    department_id = params[:department_id]
    lang = params[:lang] || 'ja'
    
    # department_idが数値の場合はDepartmentから名前で検索
    if department_id.match?(/\A\d+\z/)
      department = Department.find_by(id: department_id)
    else
      # 日本語名で検索
      department = Department.find_by(name: department_id)
    end
    
    return render_json_error('Department not found', status: :not_found) unless department
    
    courses = Course.joins(:course_departments)
                   .where(year: year, course_departments: { department_id: department.id })
                   .includes(:course_departments, :departments)
    
    response_data = courses.map do |course|
      {
        id: course.id,
        title: lang == 'ja' ? course.title_ja : course.title_en,
        ocwId: course.ocw_id,
        courseNumber: course.course_number,
        year: course.year,
        startQuarter: course.start_quarter,
        endQuarter: course.end_quarter
      }
    end
    
    render_json_success(response_data)
  end
  
  def create
    courses_data = params[:_json] || [params]
    
    ActiveRecord::Base.transaction do
      courses_data.each do |course_params|
        course = Course.create!(
          department_id: course_params[:departments].first, # 最初の学科をdepartment_idに設定
          ocw_id: course_params[:ocwId],
          course_number: course_params[:courseNumber],
          title_ja: course_params[:titleJa],
          title_en: course_params[:titleEn],
          year: course_params[:year],
          start_quarter: course_params[:startQuarter],
          end_quarter: course_params[:endQuarter]
        )
        
        # 学科との関連付け
        course_params[:departments].each do |department_id|
          CourseDepartment.create!(
            course_id: course.id,
            department_id: department_id
          )
        end
        
        # 教員の作成・関連付け
        if course_params[:teachers].present?
          course_params[:teachers].each do |teacher_params|
            CourseTeacher.create!(
              course_id: course.id,
              nameJa: teacher_params[:nameJa],
              nameEn: teacher_params[:nameEn]
            )
          end
        end
      end
    end
    
    render_json_success({ message: 'Courses created successfully' }, status: :created)
  rescue ActiveRecord::RecordInvalid => e
    render_json_error(e.message)
  end
  
  def destroy
    course_id = params[:course_id]
    course = Course.find_by(id: course_id)
    
    return render_json_error('Course not found', status: :not_found) unless course
    
    ActiveRecord::Base.transaction do
      # 関連レコードを明示的に削除
      course.course_departments.delete_all
      course.course_teachers.delete_all
      # answersはocw_idで関連付けされているため、ocw_idで削除
      Answer.where(ocw_id: course.ocw_id).delete_all
      course.delete
    end
    
    render_json_success({ message: 'Course deleted successfully' })
  rescue => e
    Rails.logger.error "Course deletion error: #{e.message}"
    render_json_error("Failed to delete course: #{e.message}")
  end
end
