defmodule Sender do
  def send_email(email) do
    Process.sleep(300)
    IO.puts("Email sent to #{email}")
    {:ok, "email_sent"}
  end

  def notify_all(emails) do
    emails
    |> Enum.map(fn email ->
      Task.async(fn ->
        send_email(email)
      end)
    end)
    |> Enum.map(&Task.await/1)
  end
end
