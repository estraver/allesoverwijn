module Trailblazer::Operation::Controller
  def reject(operation_class, options={}, &block)
    res, op = operation_for!(operation_class, options) { |params| operation_class.reject(params) }

    yield op if res and block_given?

    op
  end

end