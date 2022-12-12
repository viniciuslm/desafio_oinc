defmodule Oinc.App do
  use Commanded.Application, otp_app: :oinc

  router(Oinc.Router)
end
