# Nix language essentials

The Nix language is a lazy, pure, functional language used to describe derivations (build tasks) and configuration. You only need a small subset of it to read and write most Nix files.

## Values

### Primitive values

- **Strings**: double-quoted, escape with `\`. Indented strings use `''...''` and are convenient for multi-line shell code.

  ```nix
  "hello"
  "line one\nline two"
  ''
    #!/bin/sh
    echo "hello world"
  ''
  ```

- **Numbers**: `42`, `3.14`.
- **Booleans**: `true`, `false`.
- **Null**: `null`.
- **Paths**: written as `./file.txt` or `/nix/store/...`; relative paths are resolved at parse time.

### Lists

Lists are ordered and whitespace-separated.

```nix
[ 1 2 3 ]
[ "a" "b" ]
```

Look up with `builtins.elemAt xs n` or `lib.lists` helpers.

### Attribute sets

Attribute sets (records) are the core data structure. Access with dot notation or `set.attr`.

```nix
{ name = "hello"; version = "2.12"; }

let pkg = { name = "hello"; version = "2.12"; }; in
pkg.name
# => "hello"
```

Nested sets can be written compactly with dotted names:

```nix
{ services.httpd.enable = true; }
# equivalent to
{ services = { httpd = { enable = true; }; }; }
```

`rec` allows self-reference:

```nix
rec {
  name = "hello";
  fullName = "${name}-world";  # "hello-world"
}
```

## Functions

Functions are anonymous. The most common form is a set of named arguments:

```nix
{ name, version ? "1.0", ... }:  # ... accepts extra arguments
  "${name}-${version}"
```

Call a function by passing an attribute set:

```nix
let f = { x, y }: x + y; in
f { x = 1; y = 2; }
# => 3
```

For a single argument, you can use a regular lambda:

```nix
x: x + 1
```

Common patterns in `default.nix`:

```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "mytool";
  version = "0.1";
  src = ./.;
  buildInputs = [ pkgs.jq ];
}
```

## Key constructs

| Construct | Purpose | Example |
|-----------|---------|---------|
| `let ... in ...` | Bind local variables | `let x = 1; in x + 2` |
| `with set; ...` | Bring set attributes into scope | `with pkgs; [ jq curl ]` |
| `import path` | Import and evaluate a Nix file | `import ./helper.nix` |
| `inherit` | Copy attributes from a set | `inherit (pkgs) jq curl;` |
| `rec` | Self-referential attribute set | `rec { a = 1; b = a + 1; }` |
| `if ... then ... else ...` | Conditional | `if x then 1 else 0` |

## Derivations

A derivation is a build task described by a Nix expression. The `mkDerivation` helper from `stdenv` is the most common way to create one.

```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "example";
  version = "1.0";
  src = ./src;
  buildInputs = [ pkgs.zlib ];
  nativeBuildInputs = [ pkgs.cmake ];
  buildPhase = "make";
  installPhase = ''
    mkdir -p $out/bin
    cp mytool $out/bin/
  '';
}
```

Key attributes:

- `pname` / `version`: package name and version.
- `src`: source directory or fetched archive.
- `buildInputs`: runtime/build dependencies available in the derivation environment.
- `nativeBuildInputs`: tools that run on the build machine during the build.
- `buildPhase`, `installPhase`, etc.: shell scripts executed during the build.
- `$out`: the output path where the build must install its files.

## `builtins` you will use often

| Function | Purpose |
|----------|---------|
| `builtins.toString x` | Convert to string |
| `builtins.readFile path` | Read a file as a string |
| `builtins.fromJSON json` | Parse JSON |
| `builtins.toJSON x` | Serialize to JSON |
| `builtins.attrNames set` | List attribute names |
| `builtins.hasAttr name set` | Check attribute existence |
| `builtins.getAttr name set` | Get attribute value |
| `builtins.trace msg x` | Print a trace during evaluation |
| `builtins.map f list` | Map over a list |
| `builtins.filter f list` | Filter a list |
| `builtins.elem x list` | Membership test |

## String interpolation

Use `${...}` to interpolate values inside strings.

```nix
let name = "hello"; in
"${name}-world"
# => "hello-world"
```

Paths and derivations are interpolated to their store paths. For multi-line indented strings, interpolation works the same way.

## Best practices

- **Prefer explicit argument sets** over positional arguments in Nix files: `{ pkgs, lib, ... }:`.
- **Avoid `with pkgs;` at the top level** of large files; it makes it hard to tell where names come from. It is fine in small `shell.nix` or `buildInputs` lists.
- **Use `let` for repeated intermediate values**, not global mutable variables.
- **Indent multi-line strings with `''...''`** for shell code and configuration snippets.
- **Do not rely on file system impurity** unless you explicitly intend to (e.g., `builtins.fetchGit` with `ref` or `builtins.currentSystem`).
