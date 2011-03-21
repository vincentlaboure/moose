[Mesh]   
  [./Generation]
    dim = 2
    nx = 3
    ny = 3
    nz = 0
    zmin = 0
    zmax = 0
    elem_type = QUAD4
  [../]
[]

[Variables]
  active = 'u v'

  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
  
  [./v]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  active = 'diff1 diff2'

  [./diff1]
    type = DiffMKernel
    variable = u
    mat_prop = diff1
  [../]
  
  [./diff2]
    type = DiffMKernel
    variable = v
    mat_prop = diff2
  [../]
[]

[BCs]
  active = 'left_u right_u left_v right_v'

  # Mesh Generation produces boundaries in counter-clockwise fashion
  [./left_u]
    type = DirichletBC
    variable = u
    boundary = 3
    value = 0
  [../]

  [./right_u]
    type = DirichletBC
    variable = u
    boundary = 1
    value = 1
  [../]

  [./left_v]
    type = DirichletBC
    variable = v
    boundary = 3
    value = 1
  [../]

  [./right_v]
    type = DirichletBC
    variable = v
    boundary = 1
    value = 0
  [../]
[]

[Materials]
  active = 'dm1 dm2'

  [./dm1]
    type = Diff1Material
    block = 0
    diff = 2
  [../]

  [./dm2]
    type = Diff2Material
    block = 0
    diff = 4
  [../]
[]

[Executioner]
  type = Steady
  perf_log = true
  petsc_options = '-snes_mf_operator'
[]

[Output]
  file_base = out
  output_initial = true
  interval = 1
  exodus = true
[]

