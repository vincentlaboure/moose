[Mesh]
  type = GeneratedMesh
  nx = 5
  ny = 5
  dim = 2
  xmax = 10
  ymax = 10
  parallel_type = replicated
  uniform_refine = 2
[]

[Functions]
  [./func]
    type = ParsedFunction
    value = 'x'
  [../]
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

[AuxKernels]
  [./pwr_dens]
    type = FunctionAux
    variable = power_density
    function = func
    execute_on = 'initial timestep_end'
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = u
    boundary = left
    value = 0
  [../]
  [./right]
    type = DirichletBC
    variable = u
    boundary = right
    value = 10
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
  [./power_density_avg]
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

[MultiApps]
  [./sub_app]
    positions = '4 4 0'
    type = FullSolveMultiApp
    input_files = sub.i
    app_type = RattlesnakeApp # change that appropriately to match application
    execute_on = 'nonlinear'
    # use_displaced_mesh = true
  [../]
[]

[Transfers]
  [./to_sub_power_density] #
    type = MultiAppMeshFunctionTransfer # for some reason MultiAppNearestNodeTransfer doesn't work
                                        # and MultiAppMeshFunctionTransfer does not seem conservative
                                        # if the master is more refined than the slave
    direction = to_multiapp
    multi_app = sub_app
    variable = power_density
    source_variable = power_density
    execute_on = 'initial nonlinear'
    displaced_source_mesh = false
    displaced_target_mesh = false
    use_displaced_mesh = false
  [../]
[]

[Outputs]
  exodus = true
[]
