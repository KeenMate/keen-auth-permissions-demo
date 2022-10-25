defmodule KeenAuthPermissionsDemo.SMSSender do
  require Logger

  @type phone_number() :: Provider.phone_number()
  @type sms_body() :: Provider.sms_body()
  @type result() :: Provider.result()

  def send_sms(to, message) do
    ExTwilio.Message.create(
      to: to,
      body: message,
      messaging_service_sid:
        Application.fetch_env!(:keen_auth_permissions_demo, :twilio_service_sid)
        |> IO.inspect(label: "Twilio SID")
      # status_callback: "http://97313c4346f0.ngrok.io/api/sms/notify"
    )
    |> case do
      {:ok, _} ->
        :ok

      {:error, %{"code" => 21604}, 400} ->
        {:error, :missing_phone}

      {:error, %{"code" => 21211}, 400} ->
        {:error, :invalid_phone}

      {:error, data, status_code} ->
        Logger.error("Error occurred while sending sms", reason: inspect(data))
        {:error, {data, status_code}}
    end
  end
end
