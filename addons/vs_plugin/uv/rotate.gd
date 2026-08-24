# Source: https://github.com/arkology/ShaderV

@tool
class_name VisualShaderNodeUVrotate
extends VisualShaderNodeCustom


#region Metadata

func _get_name() -> String:
	return "RotateUV"

func _get_category() -> String:
	return "UV"

func _get_description() -> String:
	return "Rotate UV by angle relative to pivot vector"

func _get_return_icon_type() -> PortType:
	return VisualShaderNode.PORT_TYPE_VECTOR_2D

#endregion


#region Input Ports

func _get_input_port_count() -> int:
	return 3

func _get_input_port_name(port: int) -> String:
	match port:
		0:
			return "uv"
		1:
			return "angle (rad.)"
		2:
			return "pivot"
	return ""

func _get_input_port_type(port: int) -> PortType:
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR
		2:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
	return VisualShaderNode.PORT_TYPE_SCALAR

#endregion


#region Output Ports

func _get_output_port_count() -> int:
	return 1

func _get_output_port_name(port: int) -> String:
	return "uv"

func _get_output_port_type(port: int) -> PortType:
	return VisualShaderNode.PORT_TYPE_VECTOR_2D

#endregion


#region Shader Code Generation

func _get_global_code(mode: Shader.Mode) -> String:
	var code = preload("rotate.gdshader").code
	code = code.replace("shader_type spatial;\n", "")
	return code

func _get_code(input_vars: Array[String], output_vars: Array[String], mode: Shader.Mode, type: VisualShader.Type) -> String:
	# Fallback values when ports are unconnected
	var uv = "UV"

	if input_vars[0]:
		uv = input_vars[0]

	return output_vars[0] + " = r0tateUVFunc(%s.xy, %s.xy, %s);" % [uv, input_vars[2], input_vars[1]]

#endregion


#region Initialization

func _init() -> void:
	set_input_port_default_value(1, 0.0)                  # angle (rad.)
	set_input_port_default_value(2, Vector2(0.5, 0.5))    # pivot

#endregion