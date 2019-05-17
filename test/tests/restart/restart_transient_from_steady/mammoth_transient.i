[Mesh]
  type = FileMesh
  file = mammoth_eigenvalue_out_cp/LATEST
[]

[Problem]
  restart_file_base = mammoth_eigenvalue_out_cp/LATEST
  force_restart = true
[]

[Variables]
  [power_density]
  []
[]

[Functions]
  [pwr_func]
    type = ParsedFunction
    value = '1e3*x*(1-x)+5e3' # increase this function to drive transient
  []
[]

[Kernels]
  [timedt]
    type = TimeDerivative
    variable = power_density
  []

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
[]

[Executioner]
  type = Transient
  start_time = 0
  end_time = 1
  dt = 0.2

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'

  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-7

  picard_rel_tol = 1E-7
  picard_abs_tol = 1.0e-07
  picard_max_its = 4
[]

[Outputs]
  exodus = true
  csv = true
  perf_graph = true
[]
