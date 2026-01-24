class StatsController < ApplicationController
  def index
    @total_orders = CompletedOrder.count

    @total_tyholt = CompletedOrder.sum(:tyholt)
    @total_pina   = CompletedOrder.sum(:pina)
    @total_mojito = CompletedOrder.sum(:mojito)
    @total_drinks = @total_tyholt + @total_pina + @total_mojito
    
    # @by_color = CompletedOrder.group(:color).count

    half_hour = Arel.sql(half_hour_sql)

    @by_half_hour = CompletedOrder
      .where(created_at: event_range)
      .group(half_hour)
      .order(half_hour)
      .pluck(
        half_hour,
        Arel.sql("SUM(tyholt)"),
        Arel.sql("SUM(pina)"),
        Arel.sql("SUM(mojito)")
      )
  end
  def reset
    CompletedOrder.delete_all
    redirect_to stats_path, notice: "Štatistiky boli resetované"
  end
  
  private

  def event_range
    #anchored to the day of the event
    # change this to only show the statistics from the event window
    # or change to (...) to see all time statistics
  start  = Time.zone.parse("2026-01-24 12:00")
  finish = Time.zone.parse("2026-02-01 03:00")
  start..finish
end


  def half_hour_sql
    <<~SQL.squish
      date_trunc(
        'hour',
        created_at AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Bratislava'
      )
      + floor(
          date_part(
            'minute',
            created_at AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Bratislava'
          ) / 30
        ) * interval '30 minutes'
    SQL
  end

end