# damszew.dev

Personal blog for sharing thoughts about different practices and patters used to create clean and efficient software

## Build

Due to nix flakes not playing nice with git submodules and [NixOs/nix#9530](https://github.com/NixOS/nix/issues/9530), it is necessary to use workaround to build this blogs flake:

```sh
nix build "git+file://$(pwd)?submodules=1"
```

## License

See the [LICENSE.md](LICENSE.md) file for details.
