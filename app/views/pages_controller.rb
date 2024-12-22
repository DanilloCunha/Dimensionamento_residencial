class PagesController < ApplicationController
  def home
    @voltage = params[:voltage].to_f
    @power = params[:power].to_f
    @distance = params[:distance].to_f
    @circuit_type = params[:circuit_type]

    if @power.present? && @distance.present? && @circuit_type.present? && @voltage.present? && @voltage > 0
      @current = @power / @voltage
      @cable_section, @max_current, @recommendation = ElectricalCalculator.suggest_cable_section(@current, @distance, @circuit_type)
      @circuit_breaker = ElectricalCalculator.suggest_circuit_breaker(@current)
      @voltage_drop = ElectricalCalculator.calculate_voltage_drop(@cable_section, @current, @distance, @voltage)
      @compliance = @voltage_drop <= 4 ? "Atende NBR 5410" : "Não atende NBR 5410"
    end
  end
end
