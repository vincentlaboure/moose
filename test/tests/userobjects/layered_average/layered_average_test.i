[Mesh]
  type = FileMesh
  file = layered_average_in.e
  parallel_type = replicated
  uniform_refine = 1
[]

[Variables]
  [./u]
  [../]
[]

[AuxVariables]
  [./master_app_var]
    order = CONSTANT
    family = MONOMIAL
    block = '23 33'
  [../]
[]

[AuxKernels]
  [./layered_aux]
    type = SpatialUserObjectAux
    variable = master_app_var
    execute_on = timestep_end
    user_object = master_uo
    block = '23 33'
  [../]
[]

[UserObjects]
  [./master_uo]
    type = LayeredAverage
    direction = x
    variable = u
    block = '23 33'
    bounds = '0.25 0.375 0.5 0.75'
    # num_layers = 4
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
    value = 100
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
  [./u_avg]
    type = ElementAverageValue
    variable = u
    execute_on = 'initial timestep_end'
  [../]
  [./final_avg]
    type = ElementAverageValue
    variable = master_app_var
    execute_on = 'initial timestep_end'
    block = '23 33'
  [../]
[]


[Outputs]
  exodus = true
  file_base = layered_average_out
[]
