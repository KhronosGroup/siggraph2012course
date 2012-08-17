/**
 * @fileoverview
 * Registers a language handler for GLSL.
 *
 * Based on the lexical grammar and keywords at
 * http://www.khronos.org/registry/gles/specs/2.0/GLSL_ES_Specification_1.0.17.pdf
 * as well as the VHDL and other grammars in this package.
 *
 * @author kbr@chromium.org
 */

PR['registerLangHandler'](
    PR['createSimpleLexer'](
        [
         // Whitespace
         [PR['PR_PLAIN'], /^[\t\n\r \xA0]+/, null, '\t\n\r \xA0']
        ],
        [
         // String, character or bit string
         [PR['PR_STRING'], /^(?:[BOX]?"(?:[^\"]|"")*"|'.')/i],
         [PR['PR_KEYWORD'], /^(?:attribute|break|const|continue|discard|do|else|for|gl_FragColor|gl_FragData|gl_Position|highp|if|in|inout|invariant|lowp|mediump|out|precision|return|struct|uniform|varying|while)(?=[^\w-]|$)/i, null],
         // Type, predefined or standard
         [PR['PR_TYPE'], /^(?:bool|bvec2|bvec3|bvec4|float|int|ivec2|ivec3|ivec4|mat2|mat3|mat4|sampler2D|samplerCube|vec2|vec3|vec4|void)(?=[^\w-]|$)/i, null],
         // Number, decimal or based literal
         [PR['PR_LITERAL'], /^\d+(?:_\d+)*(?:#[\w\\.]+#(?:[+\-]?\d+(?:_\d+)*)?|(?:\.\d+(?:_\d+)*)?(?:E[+\-]?\d+(?:_\d+)*)?)/i],
         // Identifier, basic or extended
         [PR['PR_PLAIN'], /^(?:[a-z]\w*|\\[^\\]*\\)/i],
         // Punctuation
         [PR['PR_PUNCTUATION'], /^[^\w\t\n\r \xA0\"\'][^\w\t\n\r \xA0\-\"\']*/]
        ]),
    ['glsl']);
