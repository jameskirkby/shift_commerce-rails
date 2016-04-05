module ShiftCommerce
  module Rails
    class Password
      include ActiveModel::Model
      attr_accessor :email, :reset_password_token, :password
    end
  end
end