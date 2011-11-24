start 
= statement+

statement 
= _ lb stmt:(decl / expr) _ lb { 
	return stmt; 
}

decl
= ws+ id:[a-zA-Z]+ ws* "=" ws* val:expr { 
	return { 
		type: "declaration", 
		name: id.join(""), 
		value: val 
	} 
}

expr 
= binop / unary

unary
= op:[!~] operand:(unary / expr) {
	return { 
		type: "unary", 
		operator: op, 
		arg: operand 
	}
} / primary

oper = [+-/*&^%|] / ">>" / "<<"

binop
= left:(primary / unary) ws* op:oper ws* right:expr {
	return {
		type: "binop",
		operator: op,
		args: [left, right]
	}
}

primary
= (identifier / literal / paren)

identifier 
= call / id:[a-zA-Z]+ { 
	return {
		type: "variable", 
		name:id.join("")
	}
}

literal 
= val:(real / integer) {
	return {
		type: "literal",
		value: val
	}
}

fn
= "aprenda" id:[a-zA-Z]+ parameters:((ws? [a-zA-Z]+)+)? ws* body:block { 
	return { 
		type: "function", 
		params: parameters ? parameters.map(function(a) { return a[1].join("") }) : null ,
                code: body
	} 
}

integer
= digits:[0-9]+ { 
	return parseInt(digits.join("")); 
}

real
= digits:(integer "." integer) { 
	return parseFloat(digits.join("")); 
}

paren
= "(" val:expr ")" {
	return val;
}

block
= ":" _ lb val:statement* _ lb "." {
	return {
		type: "block",
		value: val
	}
}

call
= id:[a-zA-Z]+ args:((ws? expr)+)? {
	return {
		type: "call",
		name: id.join(""),
		arguments: args ? args.map(function(a) { return a[1] }) : null
	}
}

ws 
= [ \t]

lb 
= "\n"*

comment 
= "#" [^"\n"]* lb

_ 
= (ws / comment)*
