[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = 0
    xmax = 1
    nx = 1
  []
[]

[Variables]
  [u]
  []
[]

[Kernels]
  [diff]
    type = Diffusion
    variable = u
  []
  [reac]
    type = Reaction
    variable = u
  []
[]

[BCs]
  [right]
    type = DirichletBC
    variable = u
    value = 1
    boundary = right
  []
[]

[AuxVariables]
  [v]
  []
  [w]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  active = 'set_v set_w_option3'
  [set_v]
    type = NormalizationAux
    variable = v
    source_variable = u
    execute_on = 'linear nonlinear'
  []
  [set_w_option1]
    type = RandomAux
    variable = w
    random_user_object = random_uo
    execute_on = 'linear nonlinear'
  []
  [set_w_option2]
    type = RandomAux
    variable = w
    random_user_object = random_uo
    execute_on = 'final'
  []
  [set_w_option3]
    type = ConstantAux
    variable = w
    execute_on = 'final'
  []
[]

[UserObjects]
  [random_uo]
    type = RandomElementalUserObject
    execute_on = 'linear nonlinear'
  []
[]

[Executioner]
  type = Steady
[]
