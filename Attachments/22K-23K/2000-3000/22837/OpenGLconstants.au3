; Version ;
Global Const $GL_VERSION_1_1 = 1

; AccumOp ;
Global Const $GL_ACCUM = 0x0100
Global Const $GL_LOAD = 0x0101
Global Const $GL_RETURN = 0x0102
Global Const $GL_MULT = 0x0103
Global Const $GL_ADD = 0x0104

; AlphaFunction ;
Global Const $GL_NEVER = 0x0200
Global Const $GL_LESS = 0x0201
Global Const $GL_EQUAL = 0x0202
Global Const $GL_LEQUAL = 0x0203
Global Const $GL_GREATER = 0x0204
Global Const $GL_NOTEQUAL = 0x0205
Global Const $GL_GEQUAL = 0x0206
Global Const $GL_ALWAYS = 0x0207

; Attrib$mask ;
Global Const $GL_CURRENT_BIT = 0x00000001
Global Const $GL_POINT_BIT = 0x00000002
Global Const $GL_LINE_BIT = 0x00000004
Global Const $GL_POLYGON_BIT = 0x00000008
Global Const $GL_POLYGON_STIPPLE_BIT = 0x00000010
Global Const $GL_PIXEL_MODE_BIT = 0x00000020
Global Const $GL_LIGHTING_BIT = 0x00000040
Global Const $GL_FOG_BIT = 0x00000080
Global Const $GL_DEPTH_BUFFER_BIT = 0x00000100
Global Const $GL_ACCUM_BUFFER_BIT = 0x00000200
Global Const $GL_STENCIL_BUFFER_BIT = 0x00000400
Global Const $GL_VIEWPORT_BIT = 0x00000800
Global Const $GL_TRANSFORM_BIT = 0x00001000
Global Const $GL_ENABLE_BIT = 0x00002000
Global Const $GL_COLOR_BUFFER_BIT = 0x00004000
Global Const $GL_HINT_BIT = 0x00008000
Global Const $GL_EVAL_BIT = 0x00010000
Global Const $GL_LIST_BIT = 0x00020000
Global Const $GL_TEXTURE_BIT = 0x00040000
Global Const $GL_SCISSOR_BIT = 0x00080000
Global Const $GL_ALL_ATTRIB_BITS = 0x000fffff

; BeginMode ;
Global Const $GL_POINTS = 0x0000
Global Const $GL_LINES = 0x0001
Global Const $GL_LINE_LOOP = 0x0002
Global Const $GL_LINE_STRIP = 0x0003
Global Const $GL_TRIANGLES = 0x0004
Global Const $GL_TRIANGLE_STRIP = 0x0005
Global Const $GL_TRIANGLE_FAN = 0x0006
Global Const $GL_QUADS = 0x0007
Global Const $GL_QUAD_STRIP = 0x0008
Global Const $GL_POLYGON = 0x0009

; BlendingFactorDest ;
Global Const $GL_ZERO = 0
Global Const $GL_ONE = 1
Global Const $GL_SRC_COLOR = 0x0300
Global Const $GL_ONE_MINUS_SRC_COLOR = 0x0301
Global Const $GL_SRC_ALPHA = 0x0302
Global Const $GL_ONE_MINUS_SRC_ALPHA = 0x0303
Global Const $GL_DST_ALPHA = 0x0304
Global Const $GL_ONE_MINUS_DST_ALPHA = 0x0305

; BlendingFactorSrc ;
Global Const $GL_DST_COLOR = 0x0306
Global Const $GL_ONE_MINUS_DST_COLOR = 0x0307
Global Const $GL_SRC_ALPHA_SATURATE = 0x0308

; Boolean ;
Global Const $GL_TRUE = 1
Global Const $GL_FALSE = 0

; ClipPlaneName ;
Global Const $GL_CLIP_PLANE0 = 0x3000
Global Const $GL_CLIP_PLANE1 = 0x3001
Global Const $GL_CLIP_PLANE2 = 0x3002
Global Const $GL_CLIP_PLANE3 = 0x3003
Global Const $GL_CLIP_PLANE4 = 0x3004
Global Const $GL_CLIP_PLANE5 = 0x3005

; Data$type ;
Global Const $GL_BYTE = 0x1400
Global Const $GL_UNSIGNED_BYTE = 0x1401
Global Const $GL_SHORT = 0x1402
Global Const $GL_UNSIGNED_SHORT = 0x1403
Global Const $GL_INT = 0x1404
Global Const $GL_UNSIGNED_INT = 0x1405
Global Const $GL_FLOAT = 0x1406
Global Const $GL_2_BYTES = 0x1407
Global Const $GL_3_BYTES = 0x1408
Global Const $GL_4_BYTES = 0x1409
Global Const $GL_DOUBLE = 0x140A

; DrawBufferMode ;
Global Const $GL_NONE = 0
Global Const $GL_FRONT_LEFT = 0x0400
Global Const $GL_FRONT_RIGHT = 0x0401
Global Const $GL_BACK_LEFT = 0x0402
Global Const $GL_BACK_RIGHT = 0x0403
Global Const $GL_FRONT = 0x0404
Global Const $GL_BACK = 0x0405
Global Const $GL_LEFT = 0x0406
Global Const $GL_RIGHT = 0x0407
Global Const $GL_FRONT_AND_BACK = 0x0408
Global Const $GL_AUX0 = 0x0409
Global Const $GL_AUX1 = 0x040A
Global Const $GL_AUX2 = 0x040B
Global Const $GL_AUX3 = 0x040C

; ErrorCode ;
Global Const $GL_NO_ERROR = 0
Global Const $GL_INVALID_ENUM = 0x0500
Global Const $GL_INVALID_VALUE = 0x0501
Global Const $GL_INVALID_OPERATION = 0x0502
Global Const $GL_STACK_OVERFLOW = 0x0503
Global Const $GL_STACK_UNDERFLOW = 0x0504
Global Const $GL_OUT_OF_MEMORY = 0x0505

; FeedBackMode ;
Global Const $GL_2D = 0x0600
Global Const $GL_3D = 0x0601
Global Const $GL_3D_COLOR = 0x0602
Global Const $GL_3D_COLOR_TEXTURE = 0x0603
Global Const $GL_4D_COLOR_TEXTURE = 0x0604

; FeedBackToken ;
Global Const $GL_PASS_THROUGH_TOKEN = 0x0700
Global Const $GL_POINT_TOKEN = 0x0701
Global Const $GL_LINE_TOKEN = 0x0702
Global Const $GL_POLYGON_TOKEN = 0x0703
Global Const $GL_BITMAP_TOKEN = 0x0704
Global Const $GL_DRAW_PIXEL_TOKEN = 0x0705
Global Const $GL_COPY_PIXEL_TOKEN = 0x0706
Global Const $GL_LINE_RESET_TOKEN = 0x0707

; FogMode ;
Global Const $GL_EXP = 0x0800
Global Const $GL_EXP2 = 0x0801

; FrontFaceDirection ;
Global Const $GL_CW = 0x0900
Global Const $GL_CCW = 0x0901

; GetMap$target ;
Global Const $GL_COEFF = 0x0A00
Global Const $GL_ORDER = 0x0A01
Global Const $GL_DOMAIN = 0x0A02

; Get$target ;
Global Const $GL_CURRENT_COLOR = 0x0B00
Global Const $GL_CURRENT_INDEX = 0x0B01
Global Const $GL_CURRENT_NORMAL = 0x0B02
Global Const $GL_CURRENT_TEXTURE_COORDS = 0x0B03
Global Const $GL_CURRENT_RASTER_COLOR = 0x0B04
Global Const $GL_CURRENT_RASTER_INDEX = 0x0B05
Global Const $GL_CURRENT_RASTER_TEXTURE_COORD = 0x0B06
Global Const $GL_CURRENT_RASTER_POSITION = 0x0B07
Global Const $GL_CURRENT_RASTER_POSITION_VALID = 0x0B08
Global Const $GL_CURRENT_RASTER_DISTANCE = 0x0B09
Global Const $GL_POINT_SMOOTH = 0x0B10
Global Const $GL_POINT_SIZE = 0x0B11
Global Const $GL_POINT_SIZE_RANGE = 0x0B12
Global Const $GL_POINT_SIZE_GRANULARITY = 0x0B13
Global Const $GL_LINE_SMOOTH = 0x0B20
Global Const $GL_LINE_WIDTH = 0x0B21
Global Const $GL_LINE_WIDTH_RANGE = 0x0B22
Global Const $GL_LINE_WIDTH_GRANULARITY = 0x0B23
Global Const $GL_LINE_STIPPLE = 0x0B24
Global Const $GL_LINE_STIPPLE_PATTERN = 0x0B25
Global Const $GL_LINE_STIPPLE_REPEAT = 0x0B26
Global Const $GL_LIST_MODE = 0x0B30
Global Const $GL_MAX_LIST_NESTING = 0x0B31
Global Const $GL_LIST_BASE = 0x0B32
Global Const $GL_LIST_INDEX = 0x0B33
Global Const $GL_POLYGON_MODE = 0x0B40
Global Const $GL_POLYGON_SMOOTH = 0x0B41
Global Const $GL_POLYGON_STIPPLE = 0x0B42
Global Const $GL_EDGE_FLAG = 0x0B43
Global Const $GL_CULL_FACE = 0x0B44
Global Const $GL_CULL_FACE_MODE = 0x0B45
Global Const $GL_FRONT_FACE = 0x0B46
Global Const $GL_LIGHTING = 0x0B50
Global Const $GL_LIGHT_MODEL_LOCAL_VIEWER = 0x0B51
Global Const $GL_LIGHT_MODEL_TWO_SIDE = 0x0B52
Global Const $GL_LIGHT_MODEL_AMBIENT = 0x0B53
Global Const $GL_SHADE_MODEL = 0x0B54
Global Const $GL_COLOR_MATERIAL_FACE = 0x0B55
Global Const $GL_COLOR_MATERIAL_PARAMETER = 0x0B56
Global Const $GL_COLOR_MATERIAL = 0x0B57
Global Const $GL_FOG = 0x0B60
Global Const $GL_FOG_INDEX = 0x0B61
Global Const $GL_FOG_DENSITY = 0x0B62
Global Const $GL_FOG_START = 0x0B63
Global Const $GL_FOG_END = 0x0B64
Global Const $GL_FOG_MODE = 0x0B65
Global Const $GL_FOG_COLOR = 0x0B66
Global Const $GL_DEPTH_RANGE = 0x0B70
Global Const $GL_DEPTH_TEST = 0x0B71
Global Const $GL_DEPTH_WRITEMASK = 0x0B72
Global Const $GL_DEPTH_CLEAR_VALUE = 0x0B73
Global Const $GL_DEPTH_FUNC = 0x0B74
Global Const $GL_ACCUM_CLEAR_VALUE = 0x0B80
Global Const $GL_STENCIL_TEST = 0x0B90
Global Const $GL_STENCIL_CLEAR_VALUE = 0x0B91
Global Const $GL_STENCIL_FUNC = 0x0B92
Global Const $GL_STENCIL_VALUE_MASK = 0x0B93
Global Const $GL_STENCIL_FAIL = 0x0B94
Global Const $GL_STENCIL_PASS_DEPTH_FAIL = 0x0B95
Global Const $GL_STENCIL_PASS_DEPTH_PASS = 0x0B96
Global Const $GL_STENCIL_REF = 0x0B97
Global Const $GL_STENCIL_WRITEMASK = 0x0B98
Global Const $GL_MATRIX_MODE = 0x0BA0
Global Const $GL_NORMALIZE = 0x0BA1
Global Const $GL_VIEWPORT = 0x0BA2
Global Const $GL_MODELVIEW_STACK_DEPTH = 0x0BA3
Global Const $GL_PROJECTION_STACK_DEPTH = 0x0BA4
Global Const $GL_TEXTURE_STACK_DEPTH = 0x0BA5
Global Const $GL_MODELVIEW_MATRIX = 0x0BA6
Global Const $GL_PROJECTION_MATRIX = 0x0BA7
Global Const $GL_TEXTURE_MATRIX = 0x0BA8
Global Const $GL_ATTRIB_STACK_DEPTH = 0x0BB0
Global Const $GL_CLIENT_ATTRIB_STACK_DEPTH = 0x0BB1
Global Const $GL_ALPHA_TEST = 0x0BC0
Global Const $GL_ALPHA_TEST_FUNC = 0x0BC1
Global Const $GL_ALPHA_TEST_REF = 0x0BC2
Global Const $GL_DITHER = 0x0BD0
Global Const $GL_BLEND_DST = 0x0BE0
Global Const $GL_BLEND_SRC = 0x0BE1
Global Const $GL_BLEND = 0x0BE2
Global Const $GL_LOGIC_OP_MODE = 0x0BF0
Global Const $GL_INDEX_LOGIC_OP = 0x0BF1
Global Const $GL_COLOR_LOGIC_OP = 0x0BF2
Global Const $GL_AUX_BUFFERS = 0x0C00
Global Const $GL_DRAW_BUFFER = 0x0C01
Global Const $GL_READ_BUFFER = 0x0C02
Global Const $GL_SCISSOR_BOX = 0x0C10
Global Const $GL_SCISSOR_TEST = 0x0C11
Global Const $GL_INDEX_CLEAR_VALUE = 0x0C20
Global Const $GL_INDEX_WRITEMASK = 0x0C21
Global Const $GL_COLOR_CLEAR_VALUE = 0x0C22
Global Const $GL_COLOR_WRITEMASK = 0x0C23
Global Const $GL_INDEX_MODE = 0x0C30
Global Const $GL_RGBA_MODE = 0x0C31
Global Const $GL_DOUBLEBUFFER = 0x0C32
Global Const $GL_STEREO = 0x0C33
Global Const $GL_RENDER_MODE = 0x0C40
Global Const $GL_PERSPECTIVE_CORRECTION_HINT = 0x0C50
Global Const $GL_POINT_SMOOTH_HINT = 0x0C51
Global Const $GL_LINE_SMOOTH_HINT = 0x0C52
Global Const $GL_POLYGON_SMOOTH_HINT = 0x0C53
Global Const $GL_FOG_HINT = 0x0C54
Global Const $GL_TEXTURE_GEN_S = 0x0C60
Global Const $GL_TEXTURE_GEN_T = 0x0C61
Global Const $GL_TEXTURE_GEN_R = 0x0C62
Global Const $GL_TEXTURE_GEN_Q = 0x0C63
Global Const $GL_PIXEL_MAP_I_TO_I = 0x0C70
Global Const $GL_PIXEL_MAP_S_TO_S = 0x0C71
Global Const $GL_PIXEL_MAP_I_TO_R = 0x0C72
Global Const $GL_PIXEL_MAP_I_TO_G = 0x0C73
Global Const $GL_PIXEL_MAP_I_TO_B = 0x0C74
Global Const $GL_PIXEL_MAP_I_TO_A = 0x0C75
Global Const $GL_PIXEL_MAP_R_TO_R = 0x0C76
Global Const $GL_PIXEL_MAP_G_TO_G = 0x0C77
Global Const $GL_PIXEL_MAP_B_TO_B = 0x0C78
Global Const $GL_PIXEL_MAP_A_TO_A = 0x0C79
Global Const $GL_PIXEL_MAP_I_TO_I_SIZE = 0x0CB0
Global Const $GL_PIXEL_MAP_S_TO_S_SIZE = 0x0CB1
Global Const $GL_PIXEL_MAP_I_TO_R_SIZE = 0x0CB2
Global Const $GL_PIXEL_MAP_I_TO_G_SIZE = 0x0CB3
Global Const $GL_PIXEL_MAP_I_TO_B_SIZE = 0x0CB4
Global Const $GL_PIXEL_MAP_I_TO_A_SIZE = 0x0CB5
Global Const $GL_PIXEL_MAP_R_TO_R_SIZE = 0x0CB6
Global Const $GL_PIXEL_MAP_G_TO_G_SIZE = 0x0CB7
Global Const $GL_PIXEL_MAP_B_TO_B_SIZE = 0x0CB8
Global Const $GL_PIXEL_MAP_A_TO_A_SIZE = 0x0CB9
Global Const $GL_UNPACK_SWAP_BYTES = 0x0CF0
Global Const $GL_UNPACK_LSB_FIRST = 0x0CF1
Global Const $GL_UNPACK_ROW_LENGTH = 0x0CF2
Global Const $GL_UNPACK_SKIP_ROWS = 0x0CF3
Global Const $GL_UNPACK_SKIP_PIXELS = 0x0CF4
Global Const $GL_UNPACK_ALIGNMENT = 0x0CF5
Global Const $GL_PACK_SWAP_BYTES = 0x0D00
Global Const $GL_PACK_LSB_FIRST = 0x0D01
Global Const $GL_PACK_ROW_LENGTH = 0x0D02
Global Const $GL_PACK_SKIP_ROWS = 0x0D03
Global Const $GL_PACK_SKIP_PIXELS = 0x0D04
Global Const $GL_PACK_ALIGNMENT = 0x0D05
Global Const $GL_MAP_COLOR = 0x0D10
Global Const $GL_MAP_STENCIL = 0x0D11
Global Const $GL_INDEX_SHIFT = 0x0D12
Global Const $GL_INDEX_OFFSET = 0x0D13
Global Const $GL_RED_SCALE = 0x0D14
Global Const $GL_RED_BIAS = 0x0D15
Global Const $GL_ZOOM_X = 0x0D16
Global Const $GL_ZOOM_Y = 0x0D17
Global Const $GL_GREEN_SCALE = 0x0D18
Global Const $GL_GREEN_BIAS = 0x0D19
Global Const $GL_BLUE_SCALE = 0x0D1A
Global Const $GL_BLUE_BIAS = 0x0D1B
Global Const $GL_ALPHA_SCALE = 0x0D1C
Global Const $GL_ALPHA_BIAS = 0x0D1D
Global Const $GL_DEPTH_SCALE = 0x0D1E
Global Const $GL_DEPTH_BIAS = 0x0D1F
Global Const $GL_MAX_EVAL_ORDER = 0x0D30
Global Const $GL_MAX_LIGHTS = 0x0D31
Global Const $GL_MAX_CLIP_PLANES = 0x0D32
Global Const $GL_MAX_TEXTURE_SIZE = 0x0D33
Global Const $GL_MAX_PIXEL_MAP_TABLE = 0x0D34
Global Const $GL_MAX_ATTRIB_STACK_DEPTH = 0x0D35
Global Const $GL_MAX_MODELVIEW_STACK_DEPTH = 0x0D36
Global Const $GL_MAX_NAME_STACK_DEPTH = 0x0D37
Global Const $GL_MAX_PROJECTION_STACK_DEPTH = 0x0D38
Global Const $GL_MAX_TEXTURE_STACK_DEPTH = 0x0D39
Global Const $GL_MAX_VIEWPORT_DIMS = 0x0D3A
Global Const $GL_MAX_CLIENT_ATTRIB_STACK_DEPTH = 0x0D3B
Global Const $GL_SUBPIXEL_BITS = 0x0D50
Global Const $GL_INDEX_BITS = 0x0D51
Global Const $GL_RED_BITS = 0x0D52
Global Const $GL_GREEN_BITS = 0x0D53
Global Const $GL_BLUE_BITS = 0x0D54
Global Const $GL_ALPHA_BITS = 0x0D55
Global Const $GL_DEPTH_BITS = 0x0D56
Global Const $GL_STENCIL_BITS = 0x0D57
Global Const $GL_ACCUM_RED_BITS = 0x0D58
Global Const $GL_ACCUM_GREEN_BITS = 0x0D59
Global Const $GL_ACCUM_BLUE_BITS = 0x0D5A
Global Const $GL_ACCUM_ALPHA_BITS = 0x0D5B
Global Const $GL_NAME_STACK_DEPTH = 0x0D70
Global Const $GL_AUTO_NORMAL = 0x0D80
Global Const $GL_MAP1_COLOR_4 = 0x0D90
Global Const $GL_MAP1_INDEX = 0x0D91
Global Const $GL_MAP1_NORMAL = 0x0D92
Global Const $GL_MAP1_TEXTURE_COORD_1 = 0x0D93
Global Const $GL_MAP1_TEXTURE_COORD_2 = 0x0D94
Global Const $GL_MAP1_TEXTURE_COORD_3 = 0x0D95
Global Const $GL_MAP1_TEXTURE_COORD_4 = 0x0D96
Global Const $GL_MAP1_VERTEX_3 = 0x0D97
Global Const $GL_MAP1_VERTEX_4 = 0x0D98
Global Const $GL_MAP2_COLOR_4 = 0x0DB0
Global Const $GL_MAP2_INDEX = 0x0DB1
Global Const $GL_MAP2_NORMAL = 0x0DB2
Global Const $GL_MAP2_TEXTURE_COORD_1 = 0x0DB3
Global Const $GL_MAP2_TEXTURE_COORD_2 = 0x0DB4
Global Const $GL_MAP2_TEXTURE_COORD_3 = 0x0DB5
Global Const $GL_MAP2_TEXTURE_COORD_4 = 0x0DB6
Global Const $GL_MAP2_VERTEX_3 = 0x0DB7
Global Const $GL_MAP2_VERTEX_4 = 0x0DB8
Global Const $GL_MAP1_GRID_DOMAIN = 0x0DD0
Global Const $GL_MAP1_GRID_SEGMENTS = 0x0DD1
Global Const $GL_MAP2_GRID_DOMAIN = 0x0DD2
Global Const $GL_MAP2_GRID_SEGMENTS = 0x0DD3
Global Const $GL_TEXTURE_1D = 0x0DE0
Global Const $GL_TEXTURE_2D = 0x0DE1
Global Const $GL_FEEDBACK_BUFFER_POINTER = 0x0DF0
Global Const $GL_FEEDBACK_BUFFER_SIZE = 0x0DF1
Global Const $GL_FEEDBACK_BUFFER_TYPE = 0x0DF2
Global Const $GL_SELECTION_BUFFER_POINTER = 0x0DF3
Global Const $GL_SELECTION_BUFFER_SIZE = 0x0DF4

; GetTexture$parameter ;
Global Const $GL_TEXTURE_WIDTH = 0x1000
Global Const $GL_TEXTURE_HEIGHT = 0x1001
Global Const $GL_TEXTURE_INTERNAL_FORMAT = 0x1003
Global Const $GL_TEXTURE_BORDER_COLOR = 0x1004
Global Const $GL_TEXTURE_BORDER = 0x1005

; HintMode ;
Global Const $GL_DONT_CARE = 0x1100
Global Const $GL_FASTEST = 0x1101
Global Const $GL_NICEST = 0x1102

; $lightName ;
Global Const $GL_LIGHT0 = 0x4000
Global Const $GL_LIGHT1 = 0x4001
Global Const $GL_LIGHT2 = 0x4002
Global Const $GL_LIGHT3 = 0x4003
Global Const $GL_LIGHT4 = 0x4004
Global Const $GL_LIGHT5 = 0x4005
Global Const $GL_LIGHT6 = 0x4006
Global Const $GL_LIGHT7 = 0x4007

; $light$parameter ;
Global Const $GL_AMBIENT = 0x1200
Global Const $GL_DIFFUSE = 0x1201
Global Const $GL_SPECULAR = 0x1202
Global Const $GL_POSITION = 0x1203
Global Const $GL_SPOT_DIRECTION = 0x1204
Global Const $GL_SPOT_EXPONENT = 0x1205
Global Const $GL_SPOT_CUTOFF = 0x1206
Global Const $GL_CONSTANT_ATTENUATION = 0x1207
Global Const $GL_LINEAR_ATTENUATION = 0x1208
Global Const $GL_QUADRATIC_ATTENUATION = 0x1209

; ListMode ;
Global Const $GL_COMPILE = 0x1300
Global Const $GL_COMPILE_AND_EXECUTE = 0x1301

; LogicOp ;
Global Const $GL_CLEAR = 0x1500
Global Const $GL_AND = 0x1501
Global Const $GL_AND_REVERSE = 0x1502
Global Const $GL_COPY = 0x1503
Global Const $GL_AND_INVERTED = 0x1504
Global Const $GL_NOOP = 0x1505
Global Const $GL_XOR = 0x1506
Global Const $GL_OR = 0x1507
Global Const $GL_NOR = 0x1508
Global Const $GL_EQUIV = 0x1509
Global Const $GL_INVERT = 0x150A
Global Const $GL_OR_REVERSE = 0x150B
Global Const $GL_COPY_INVERTED = 0x150C
Global Const $GL_OR_INVERTED = 0x150D
Global Const $GL_NAND = 0x150E
Global Const $GL_SET = 0x150F

; Material$parameter ;
Global Const $GL_EMISSION = 0x1600
Global Const $GL_SHININESS = 0x1601
Global Const $GL_AMBIENT_AND_DIFFUSE = 0x1602
Global Const $GL_COLOR_INDEXES = 0x1603

; MatrixMode ;
Global Const $GL_MODELVIEW = 0x1700
Global Const $GL_PROJECTION = 0x1701
Global Const $GL_TEXTURE = 0x1702

; PixelCopy$type ;
Global Const $GL_COLOR = 0x1800
Global Const $GL_DEPTH = 0x1801
Global Const $GL_STENCIL = 0x1802

; Pixel$format ;
Global Const $GL_COLOR_INDEX = 0x1900
Global Const $GL_STENCIL_INDEX = 0x1901
Global Const $GL_DEPTH_COMPONENT = 0x1902
Global Const $GL_RED = 0x1903
Global Const $GL_GREEN = 0x1904
Global Const $GL_BLUE = 0x1905
Global Const $GL_ALPHA = 0x1906
Global Const $GL_RGB = 0x1907
Global Const $GL_RGBA = 0x1908
Global Const $GL_LUMINANCE = 0x1909
Global Const $GL_LUMINANCE_ALPHA = 0x190A

; Pixel$type ;
Global Const $GL_BITMAP = 0x1A00

; PolygonMode ;
Global Const $GL_POINT = 0x1B00
Global Const $GL_LINE = 0x1B01
Global Const $GL_FILL = 0x1B02

; RenderingMode ;
Global Const $GL_RENDER = 0x1C00
Global Const $GL_FEEDBACK = 0x1C01
Global Const $GL_SELECT = 0x1C02

; ShadingModel ;
Global Const $GL_FLAT = 0x1D00
Global Const $GL_SMOOTH = 0x1D01

; StencilOp ;
Global Const $GL_KEEP = 0x1E00
Global Const $GL_REPLACE = 0x1E01
Global Const $GL_INCR = 0x1E02
Global Const $GL_DECR = 0x1E03

; StringName ;
Global Const $GL_VENDOR = 0x1F00
Global Const $GL_RENDERER = 0x1F01
Global Const $GL_VERSION = 0x1F02
Global Const $GL_EXTENSIONS = 0x1F03

; Texture$coordName ;
Global Const $GL_S = 0x2000
Global Const $GL_T = 0x2001
Global Const $GL_R = 0x2002
Global Const $GL_Q = 0x2003

; TextureEnvMode ;
Global Const $GL_MODULATE = 0x2100
Global Const $GL_DECAL = 0x2101

; TextureEnv$parameter ;
Global Const $GL_TEXTURE_ENV_MODE = 0x2200
Global Const $GL_TEXTURE_ENV_COLOR = 0x2201

; TextureEnv$target ;
Global Const $GL_TEXTURE_ENV = 0x2300

; TextureGenMode ;
Global Const $GL_EYE_LINEAR = 0x2400
Global Const $GL_OBJECT_LINEAR = 0x2401
Global Const $GL_SPHERE_MAP = 0x2402

; TextureGen$parameter ;
Global Const $GL_TEXTURE_GEN_MODE = 0x2500
Global Const $GL_OBJECT_PLANE = 0x2501
Global Const $GL_EYE_PLANE = 0x2502

; TextureMagFilter ;
Global Const $GL_NEAREST = 0x2600
Global Const $GL_LINEAR = 0x2601

; TextureMinFilter ;
Global Const $GL_NEAREST_MIPMAP_NEAREST = 0x2700
Global Const $GL_LINEAR_MIPMAP_NEAREST = 0x2701
Global Const $GL_NEAREST_MIPMAP_LINEAR = 0x2702
Global Const $GL_LINEAR_MIPMAP_LINEAR = 0x2703

; Texture$parameterName ;
Global Const $GL_TEXTURE_MAG_FILTER = 0x2800
Global Const $GL_TEXTURE_MIN_FILTER = 0x2801
Global Const $GL_TEXTURE_WRAP_S = 0x2802
Global Const $GL_TEXTURE_WRAP_T = 0x2803

; TextureWrapMode ;
Global Const $GL_CLAMP = 0x2900
Global Const $GL_REPEAT = 0x2901

; ClientAttrib$mask ;
Global Const $GL_CLIENT_PIXEL_STORE_BIT = 0x00000001
Global Const $GL_CLIENT_VERTEX_ARRAY_BIT = 0x00000002
Global Const $GL_CLIENT_ALL_ATTRIB_BITS = 0xffffffff

; polygon_offset ;
Global Const $GL_POLYGON_OFFSET_FACTOR = 0x8038
Global Const $GL_POLYGON_OFFSET_UNITS = 0x2A00
Global Const $GL_POLYGON_OFFSET_POINT = 0x2A01
Global Const $GL_POLYGON_OFFSET_LINE = 0x2A02
Global Const $GL_POLYGON_OFFSET_FILL = 0x8037

; texture ;
Global Const $GL_ALPHA4 = 0x803B
Global Const $GL_ALPHA8 = 0x803C
Global Const $GL_ALPHA12 = 0x803D
Global Const $GL_ALPHA16 = 0x803E
Global Const $GL_LUMINANCE4 = 0x803F
Global Const $GL_LUMINANCE8 = 0x8040
Global Const $GL_LUMINANCE12 = 0x8041
Global Const $GL_LUMINANCE16 = 0x8042
Global Const $GL_LUMINANCE4_ALPHA4 = 0x8043
Global Const $GL_LUMINANCE6_ALPHA2 = 0x8044
Global Const $GL_LUMINANCE8_ALPHA8 = 0x8045
Global Const $GL_LUMINANCE12_ALPHA4 = 0x8046
Global Const $GL_LUMINANCE12_ALPHA12 = 0x8047
Global Const $GL_LUMINANCE16_ALPHA16 = 0x8048
Global Const $GL_INTENSITY = 0x8049
Global Const $GL_INTENSITY4 = 0x804A
Global Const $GL_INTENSITY8 = 0x804B
Global Const $GL_INTENSITY12 = 0x804C
Global Const $GL_INTENSITY16 = 0x804D
Global Const $GL_R3_G3_B2 = 0x2A10
Global Const $GL_RGB4 = 0x804F
Global Const $GL_RGB5 = 0x8050
Global Const $GL_RGB8 = 0x8051
Global Const $GL_RGB10 = 0x8052
Global Const $GL_RGB12 = 0x8053
Global Const $GL_RGB16 = 0x8054
Global Const $GL_RGBA2 = 0x8055
Global Const $GL_RGBA4 = 0x8056
Global Const $GL_RGB5_A1 = 0x8057
Global Const $GL_RGBA8 = 0x8058
Global Const $GL_RGB10_A2 = 0x8059
Global Const $GL_RGBA12 = 0x805A
Global Const $GL_RGBA16 = 0x805B
Global Const $GL_TEXTURE_RED_SIZE = 0x805C
Global Const $GL_TEXTURE_GREEN_SIZE = 0x805D
Global Const $GL_TEXTURE_BLUE_SIZE = 0x805E
Global Const $GL_TEXTURE_ALPHA_SIZE = 0x805F
Global Const $GL_TEXTURE_LUMINANCE_SIZE = 0x8060
Global Const $GL_TEXTURE_INTENSITY_SIZE = 0x8061
Global Const $GL_PROXY_TEXTURE_1D = 0x8063
Global Const $GL_PROXY_TEXTURE_2D = 0x8064

; texture_object ;
Global Const $GL_TEXTURE_PRIORITY = 0x8066
Global Const $GL_TEXTURE_RESIDENT = 0x8067
Global Const $GL_TEXTURE_BINDING_1D = 0x8068
Global Const $GL_TEXTURE_BINDING_2D = 0x8069

; vertex_ARRAY ;
Global Const $GL_VERTEX_ARRAY = 0x8074
Global Const $GL_NORMAL_ARRAY = 0x8075
Global Const $GL_COLOR_ARRAY = 0x8076
Global Const $GL_INDEX_ARRAY = 0x8077
Global Const $GL_TEXTURE_COORD_ARRAY = 0x8078
Global Const $GL_EDGE_FLAG_ARRAY = 0x8079
Global Const $GL_VERTEX_ARRAY_SIZE = 0x807A
Global Const $GL_VERTEX_ARRAY_TYPE = 0x807B
Global Const $GL_VERTEX_ARRAY_STRIDE = 0x807C
Global Const $GL_NORMAL_ARRAY_TYPE = 0x807E
Global Const $GL_NORMAL_ARRAY_STRIDE = 0x807F
Global Const $GL_COLOR_ARRAY_SIZE = 0x8081
Global Const $GL_COLOR_ARRAY_TYPE = 0x8082
Global Const $GL_COLOR_ARRAY_STRIDE = 0x8083
Global Const $GL_INDEX_ARRAY_TYPE = 0x8085
Global Const $GL_INDEX_ARRAY_STRIDE = 0x8086
Global Const $GL_TEXTURE_COORD_ARRAY_SIZE = 0x8088
Global Const $GL_TEXTURE_COORD_ARRAY_TYPE = 0x8089
Global Const $GL_TEXTURE_COORD_ARRAY_STRIDE = 0x808A
Global Const $GL_EDGE_FLAG_ARRAY_STRIDE = 0x808C
Global Const $GL_VERTEX_ARRAY_POINTER = 0x808E
Global Const $GL_NORMAL_ARRAY_POINTER = 0x808F
Global Const $GL_COLOR_ARRAY_POINTER = 0x8090
Global Const $GL_INDEX_ARRAY_POINTER = 0x8091
Global Const $GL_TEXTURE_COORD_ARRAY_POINTER = 0x8092
Global Const $GL_EDGE_FLAG_ARRAY_POINTER = 0x8093
Global Const $GL_V2F = 0x2A20
Global Const $GL_V3F = 0x2A21
Global Const $GL_C4UB_V2F = 0x2A22
Global Const $GL_C4UB_V3F = 0x2A23
Global Const $GL_C3F_V3F = 0x2A24
Global Const $GL_N3F_V3F = 0x2A25
Global Const $GL_C4F_N3F_V3F = 0x2A26
Global Const $GL_T2F_V3F = 0x2A27
Global Const $GL_T4F_V4F = 0x2A28
Global Const $GL_T2F_C4UB_V3F = 0x2A29
Global Const $GL_T2F_C3F_V3F = 0x2A2A
Global Const $GL_T2F_N3F_V3F = 0x2A2B
Global Const $GL_T2F_C4F_N3F_V3F = 0x2A2C
Global Const $GL_T4F_C4F_N3F_V4F = 0x2A2D

; Extensions ;
Global Const $GL_EXT_VERTEX_ARRAY = 1
Global Const $GL_EXT_BGRA = 1
Global Const $GL_EXT_PALETTED_TEXTURE = 1
Global Const $GL_WIN_SWAP_HINT = 1
Global Const $GL_WIN_DRAW_RANGE_ELEMENTS = 1

; EXT_vertex_ARRAY ;
Global Const $GL_VERTEX_ARRAY_EXT = 0x8074
Global Const $GL_NORMAL_ARRAY_EXT = 0x8075
Global Const $GL_COLOR_ARRAY_EXT = 0x8076
Global Const $GL_INDEX_ARRAY_EXT = 0x8077
Global Const $GL_TEXTURE_COORD_ARRAY_EXT = 0x8078
Global Const $GL_EDGE_FLAG_ARRAY_EXT = 0x8079
Global Const $GL_VERTEX_ARRAY_SIZE_EXT = 0x807A
Global Const $GL_VERTEX_ARRAY_TYPE_EXT = 0x807B
Global Const $GL_VERTEX_ARRAY_STRIDE_EXT = 0x807C
Global Const $GL_VERTEX_ARRAY_COUNT_EXT = 0x807D
Global Const $GL_NORMAL_ARRAY_TYPE_EXT = 0x807E
Global Const $GL_NORMAL_ARRAY_STRIDE_EXT = 0x807F
Global Const $GL_NORMAL_ARRAY_COUNT_EXT = 0x8080
Global Const $GL_COLOR_ARRAY_SIZE_EXT = 0x8081
Global Const $GL_COLOR_ARRAY_TYPE_EXT = 0x8082
Global Const $GL_COLOR_ARRAY_STRIDE_EXT = 0x8083
Global Const $GL_COLOR_ARRAY_COUNT_EXT = 0x8084
Global Const $GL_INDEX_ARRAY_TYPE_EXT = 0x8085
Global Const $GL_INDEX_ARRAY_STRIDE_EXT = 0x8086
Global Const $GL_INDEX_ARRAY_COUNT_EXT = 0x8087
Global Const $GL_TEXTURE_COORD_ARRAY_SIZE_EXT = 0x8088
Global Const $GL_TEXTURE_COORD_ARRAY_TYPE_EXT = 0x8089
Global Const $GL_TEXTURE_COORD_ARRAY_STRIDE_EXT = 0x808A
Global Const $GL_TEXTURE_COORD_ARRAY_COUNT_EXT = 0x808B
Global Const $GL_EDGE_FLAG_ARRAY_STRIDE_EXT = 0x808C
Global Const $GL_EDGE_FLAG_ARRAY_COUNT_EXT = 0x808D
Global Const $GL_VERTEX_ARRAY_POINTER_EXT = 0x808E
Global Const $GL_NORMAL_ARRAY_POINTER_EXT = 0x808F
Global Const $GL_COLOR_ARRAY_POINTER_EXT = 0x8090
Global Const $GL_INDEX_ARRAY_POINTER_EXT = 0x8091
Global Const $GL_TEXTURE_COORD_ARRAY_POINTER_EXT = 0x8092
Global Const $GL_EDGE_FLAG_ARRAY_POINTER_EXT = 0x8093
Global Const $GL_DOUBLE_EXT = $GL_DOUBLE

; EXT_bgra ;
Global Const $GL_BGR_EXT = 0x80E0
Global Const $GL_BGRA_EXT = 0x80E1

; EXT_paletted_texture ;

; These must match the GL_COLOR_TABLE_*_SGI enumerants ;
Global Const $GL_COLOR_TABLE_FORMAT_EXT = 0x80D8
Global Const $GL_COLOR_TABLE_WIDTH_EXT = 0x80D9
Global Const $GL_COLOR_TABLE_RED_SIZE_EXT = 0x80DA
Global Const $GL_COLOR_TABLE_GREEN_SIZE_EXT = 0x80DB
Global Const $GL_COLOR_TABLE_BLUE_SIZE_EXT = 0x80DC
Global Const $GL_COLOR_TABLE_ALPHA_SIZE_EXT = 0x80DD
Global Const $GL_COLOR_TABLE_LUMINANCE_SIZE_EXT = 0x80DE
Global Const $GL_COLOR_TABLE_INTENSITY_SIZE_EXT = 0x80DF

Global Const $GL_COLOR_INDEX1_EXT = 0x80E2
Global Const $GL_COLOR_INDEX2_EXT = 0x80E3
Global Const $GL_COLOR_INDEX4_EXT = 0x80E4
Global Const $GL_COLOR_INDEX8_EXT = 0x80E5
Global Const $GL_COLOR_INDEX12_EXT = 0x80E6
Global Const $GL_COLOR_INDEX16_EXT = 0x80E7

; WIN_draw_range_elements ;
Global Const $GL_MAX_ELEMENTS_VERTICES_WIN = 0x80E8
Global Const $GL_MAX_ELEMENTS_INDICES_WIN = 0x80E9

; WIN_phong_shading ;
Global Const $GL_PHONG_WIN = 0x80EA
Global Const $GL_PHONG_HINT_WIN = 0x80EB

; WIN_specular_fog ;
Global Const $GL_FOG_SPECULAR_TEXTURE_WIN = 0x80EC

