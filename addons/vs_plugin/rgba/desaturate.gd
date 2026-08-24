@tool
class_name VisualShaderNodeDesaturate
extends VisualShaderNodeCustom


#region Metadata

func _get_name() -> String:
	return "Desaturate"

func _get_category() -> String:
	return "rgba"

func _get_description() -> String:
	return "Desaturate"

func _get_return_icon_type() -> PortType:
	return PORT_TYPE_VECTOR_4D

#endregion


#region Input Ports

func _get_input_port_count() -> int:
	return 2

func _get_input_port_name(port: int) -> String:
	match port:
		0:
			return "color"
		1:
			return "amount"
	return ""

func _get_input_port_type(port: int) -> PortType:
	match port:
		0:
			return PORT_TYPE_VECTOR_4D
		1:
			return PORT_TYPE_SCALAR
	return PORT_TYPE_SCALAR

#endregion


#region Output Ports

func _get_output_port_count() -> int:
	return 1

func _get_output_port_name(port: int) -> String:
	return "result"

func _get_output_port_type(port: int) -> PortType:
	return PORT_TYPE_VECTOR_4D

#endregion


#region Shader Code Generation

func _get_global_code(mode: Shader.Mode) -> String:
	var code = preload("desaturate.gdshader").code
	code = code.replace("shader_type spatial;\n", "")
	return code

func _get_code(input_vars: Array[String], output_vars: Array[String], mode: Shader.Mode, type: VisualShader.Type) -> String:
	# Fallback values when ports are unconnected
	var color = "vec3(1.0, 1.0, 1.0)"
	var sat_amount = "0.0"

	if input_vars[0]:
		color = input_vars[0]
	if input_vars[1]:
		sat_amount = input_vars[1]

	var params = [color, sat_amount, output_vars[0]]
	return "dEsaTuraTi0n(%s, %s, %s);" % params

#endregion