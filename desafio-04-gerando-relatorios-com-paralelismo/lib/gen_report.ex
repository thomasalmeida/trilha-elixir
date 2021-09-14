defmodule GenReport do
  alias GenReport.Parser

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_template(), fn line, report -> sum_values(line, report) end)
  end

  def build, do: {:error, "Insira o nome de um arquivo"}

  def build_from_many(filenames) do
    filenames
    |> Task.async_stream(&build/1)
    |> Enum.map(& &1)
  end

  def build_from_many, do: {:error, "Insira a lista de nomes de arquivos"}

  defp sum_values(
         [name, hours, _day, month, year],
         %{
           "all_hours" => all_hours,
           "hours_per_month" => hours_per_month,
           "hours_per_year" => hours_per_year
         } = report
       ) do
    all_hours = all_hours_sum(all_hours, name, hours)
    hours_per_month = hours_per_month_sum(hours_per_month, name, month, hours)
    hours_per_year = hours_per_year_sum(hours_per_year, name, hours, year)

    report
    |> Map.put("all_hours", all_hours)
    |> Map.put("hours_per_month", hours_per_month)
    |> Map.put("hours_per_year", hours_per_year)
  end

  defp hours_per_year_sum(hours_per_year, name, hours, year) do
    years = hours_per_year[name] || %{}
    years = Map.put(years, year, (years[year] || 0) + hours)

    Map.put(hours_per_year, name, years)
  end

  defp hours_per_month_sum(hours_per_month, name, month, hours) do
    months = hours_per_month[name] || %{}
    months = Map.put(months, month, (months[month] || 0) + hours)

    Map.put(hours_per_month, name, months)
  end

  defp all_hours_sum(all_hours, name, hours) do
    Map.put(all_hours, name, (all_hours[name] || 0) + hours)
  end

  defp report_template do
    %{"all_hours" => %{}, "hours_per_month" => %{}, "hours_per_year" => %{}}
  end
end
