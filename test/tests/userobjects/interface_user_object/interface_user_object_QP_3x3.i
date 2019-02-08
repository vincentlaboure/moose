[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = 0
  ymin = 0
  xmax = 3
  ymax = 3
  nx = 3
  ny = 3
  elem_type = QUAD4
[]

[MeshModifiers]
  [./subdomain_id]
    type = AssignElementSubdomainID
    subdomain_ids = '0 0 0
                     0 1 0
                     0 0 0'
  [../]

  [./interface_01]
    type = SideSetsBetweenSubdomains
    depends_on = subdomain_id
    master_block = '1'
    paired_block = '0'
    new_boundary = 'interface_01'
  [../]
[]

[Functions]
  [./fn_exact]
    type = ParsedFunction
    value = 'x*x+y*y'
  [../]

  [./ffn]
    type = ParsedFunction
    value = -4
  [../]
[]

[UserObjects]
  [./interface_uo_qp]
    type = InterfaceUO_QP
    variable = u
    diffusivity = diffusivity
    boundary = 'interface_01'
    execute_on = 'initial LINEAR'
  [../]

[]

[Variables]
  [./u]
    family = LAGRANGE
    order = FIRST
  [../]
[]


[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]

  [./ffn]
    type = BodyForce
    variable = u
    function = ffn
  [../]
[]

[BCs]
  [./all]
    type = FunctionDirichletBC
    variable = u
    boundary = '0 1 2 3'
    function = fn_exact
  [../]
[]

[Materials]
  [./stateful1]
    type = StatefulMaterial
    block = 0
    initial_diffusivity = 5
  [../]
  [./stateful2]
    type = StatefulMaterial
    block = 1
    initial_diffusivity = 2
  [../]
  # [./interface_material]
  #   type = InterfaceUOMaterial
  #   boundary = 'interface_01 interface_02'
  #   interface_uo_qp = interface_uo_qp
  # [../]
[]


[Executioner]
  type = Steady
  solve_type = NEWTON
[]

[Outputs]
  exodus = true
[]
