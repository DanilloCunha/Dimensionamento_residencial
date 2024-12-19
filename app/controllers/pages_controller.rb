class PagesController < ApplicationController
  def home
    if params[:circuits].present?
      @results = {}

      params[:circuits].each do |circuit_number, circuit_params|
        voltage = circuit_params[:voltage].to_f
        power = circuit_params[:power].to_f
        distance = circuit_params[:distance].to_f
        circuit_type = circuit_params[:circuit_type]

        if power.positive? && distance.positive? && circuit_type.present? && voltage.positive?
          current = power / voltage
          cable_section, max_current, recommendation = ElectricalCalculator.suggest_cable_section(current, distance, circuit_type)
          circuit_breaker = ElectricalCalculator.suggest_circuit_breaker(current)
          voltage_drop = ElectricalCalculator.calculate_voltage_drop(cable_section, current, distance, voltage)
          compliance = voltage_drop <= 4 ? "Atende NBR 5410" : "Não atende NBR 5410"

          @results[circuit_number] = {
            voltage: voltage,
            current: current,
            cable_section: cable_section,
            max_current: max_current,
            recommendation: recommendation,
            circuit_breaker: circuit_breaker,
            voltage_drop: voltage_drop,
            compliance: compliance
          }
        end
      end
    end
  end
end
