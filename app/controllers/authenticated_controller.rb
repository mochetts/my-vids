class AuthenticatedController < ApplicationController
  include Authentication
  include SetCurrentRequestDetails
end