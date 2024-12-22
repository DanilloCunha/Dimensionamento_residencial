# app/services/electrical_calculator.rb
class ElectricalCalculator
  def self.suggest_cable_section(current, distance, circuit_type)
    # Tabelas de capacidade de corrente para cabos (valores aproximados)
    cable_sections = {
      1.5 => 15.5,
      2.5 => 21,
      4.0 => 28,
      6.0 => 36,
      10.0 => 50,
      16.0 => 68,
      25.0 => 89,
      35.0 => 111
    }

    # Encontra a menor seção que suporta a corrente
    suitable_section = cable_sections.find do |section, max_current|
      max_current >= current
    end

    # Se não encontrar uma seção adequada, usa a maior disponível
    suitable_section ||= cable_sections.to_a.last

    [ suitable_section[0], suitable_section[1], "Cabo #{suitable_section[0]}mm²" ]
  end

  def self.suggest_circuit_breaker(current)
    # Valores padrão de disjuntores
    breaker_values = [ 10, 16, 20, 25, 32, 40, 50, 63, 70, 80, 100 ]

    # Encontra o menor disjuntor que suporta a corrente com margem de segurança
    suitable_breaker = breaker_values.find { |value| value >= (current * 1.25) }

    # Se não encontrar um disjuntor adequado, usa o maior disponível
    suitable_breaker ||= breaker_values.last

    suitable_breaker
  end

  def self.calculate_voltage_drop(cable_section, current, distance, voltage)
    # Resistividade do cobre (Ω.mm²/m)
    resistivity = 0.0172

    # Cálculo da queda de tensão (%)
    voltage_drop = (2 * resistivity * distance * current * 100) / (cable_section * voltage)

    voltage_drop.round(2)
  end
end
