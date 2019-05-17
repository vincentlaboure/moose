[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
[]

[AuxVariables]
  [Tf]
  []
[]

[Variables]
  [power_density]
  []
[]

[Functions]
  [pwr_func]
    type = ParsedFunction
    value = '1e3*x*(1-x)+5e2'
  []
[]

[Kernels]
  [diff]
    type = Diffusion
    variable = power_density
  []

  [coupledforce]
    type = BodyForce
    variable = power_density
    function = pwr_func
  []
[]

[BCs]
  [left]
    type = DirichletBC
    variable = power_density
    boundary = left
    value = 0
  []
  [right]
    type = DirichletBC
    variable = power_density
    boundary = right
    value = 1e3
  []
[]

[Postprocessors]
  [pwr_avg]
    type = ElementAverageValue
    block = '0'
    variable = power_density
    execute_on = 'initial timestep_end'
  []
  [temp_avg]
    type = ElementAverageValue
    variable = Tf
    block = '0'
    execute_on = 'initial timestep_end'
  []
  [temp_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tf
    block = '0'
    execute_on = 'initial timestep_end'
  []
  [temp_min]
    type = ElementExtremeValue
    value_type = min
    variable = Tf
    block = '0'
    execute_on = 'initial timestep_end'
  []
[]

[Executioner]
  type = Steady
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'

  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-12

  picard_rel_tol = 1E-7
  picard_abs_tol = 1.0e-07
  picard_max_its = 12
[]

[MultiApps]
  [bison]
    type = FullSolveMultiApp
    app_type = MooseTestApp
    positions = '0 0 0'
    input_files  = bison_ss.i
    execute_on = 'timestep_end'
    no_backup_and_restore = true # to restart from the latest solve of the multiapp (for pseudo-transient)
  []
[]

[Transfers]
  [p_to_sub]
    type = MultiAppMeshFunctionTransfer
    direction = to_multiapp
    source_variable = power_density
    variable = power_density
    multi_app = bison
    execute_on = 'initial timestep_end'
  []
  [t_from_sub]
    type = MultiAppMeshFunctionTransfer
    direction = from_multiapp
    source_variable = temp
    variable = Tf
    multi_app = bison
    execute_on = 'initial timestep_end'
  []
[]

[Outputs]
  exodus = true
  csv = true
  perf_graph = true
  checkpoint = true
[]
