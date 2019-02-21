[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = 5.22
  nx = 10
[]

[Variables]
  [T]
  []
[]

[Kernels]
  [dummy]
    type = Reaction
    variable = T
  []
[]

[AuxVariables]
   [T_wall] # wall temperature (fuel side) from BISON to RELAP-7
   []
[]

[Executioner]
  type = Transient
  dt = 0.01
[]

[Postprocessors]
  [./avg_T]
    type = ElementAverageValue
    variable = T
    execute_on = 'initial timestep_end'
  [../]
  [./max_T]
    type = ElementExtremeValue
    variable = T
    value_type = max
    execute_on = 'initial timestep_end'
  [../]
  [./avg_Twall]
    type = ElementAverageValue
    variable = T_wall
    execute_on = 'initial timestep_end'
  [../]
  [./min_Twall]
    type = ElementExtremeValue
    variable = T_wall
    value_type = min
    execute_on = 'initial timestep_end'
  [../]
  [./T_in]
    type = PointValue
    variable = T_wall
    point = '5.22 0 0'
    execute_on = 'initial timestep_end'
  [../]
  [Tout]
    type = SideAverageValue
    boundary = 'left'
    variable = T
    execute_on = 'initial timestep_end'
  []
[]


[Outputs]
  [exo]
    type = Exodus
    overwrite = true
  []
  [csv]
    type = CSV
    overwrite = true
  []
[]
