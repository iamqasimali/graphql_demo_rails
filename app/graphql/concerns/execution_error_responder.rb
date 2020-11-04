module ExecutionErrorResponder
  extend ActiveSupport::Concern

  private

  def execuation_error(message: nil, status: :unprocessable_entity, code: 422)
    GraphiQL::ExecutionError.new(message, option: {status: status, code: code})
  end
end