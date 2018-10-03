[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 2
  ny = 2
  xmin = 0
  ymin = 0
  xmax = 2
  ymax = 2
[]

[Variables]
  [./u]
  [../]
[]

[AuxVariables]
  [./power_density]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  [./diff]
    type = Reaction
    variable = u
  [../]
[]

[Executioner]
  type = Steady

  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  l_tol = 1e-8
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-10
[]

[Postprocessors]
  [./pwr_density_avg]
    type = ElementAverageValue
    variable = power_density
    execute_on = 'initial timestep_end'
  [../]
  [./power_density_max]
    type = ElementExtremeValue
    variable = power_density
    value_type = max
    execute_on = 'initial timestep_end'
  [../]
[]

[Outputs]
  exodus = true
[]
