module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { errors: [
          { status: 404,
            source: { pointer: '/data/attributes/id' },
            detail: 'Record not found' }
        ]
      }, status: :not_found
    end
  end
end
