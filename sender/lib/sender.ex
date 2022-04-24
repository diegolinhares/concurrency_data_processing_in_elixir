defmodule Sender do
  @max_concurrency 2

  # It makes the task raise an error to test the supervisor
  # Without the supervisor the other tasks will be blocked
  def send_email("georgeclooney@movies.com" = email) do
    raise "Couldn't send email to #{email}"
  end

  def send_email(email) do
    Process.sleep(300)
    IO.puts("Email sent to #{email}")
    {:ok, "email_sent"}
  end

  # Ther order slows the process down because async_stream will wait for
  # a slow process to complete before moving on the next.
  # For this task, we don't care about the order, so the ordered is set to false.

  # We can kill the process by sending a kill signal using the option: on_timeout: :kill_task.
  def notify_all(emails) do
    Sender.EmailTaskSupervisor
    |> Task.Supervisor.async_stream_nolink(emails, &send_email/1)
    |> Enum.to_list()
  end
end
