# playhold-sdk-ts

Connects a web page to a [playhold](https://github.com/ny4rl4th0t3p/playhold) server: the guest's identity, joining a
room or the matchmaking queue, sending messages and receiving views. It reconnects by itself after a dropped connection,
and joins the same room again.

> **Status: early development,** like playhold itself: the API can change between 0.x versions.

It isn't on npm. Install it from this repository, by tag, which needs `git`:

```bash
npm install git+https://github.com/ny4rl4th0t3p/playhold-sdk-ts.git#v0.4.0
```

```ts
import {PlayholdClient} from "playhold-sdk";
```

The package exports its TypeScript source, so the page's build compiles it, such as with Vite. How to use it:
[TypeScript SDK](https://ny4rl4th0t3p.github.io/playhold/reference/sdk-ts.html) in playhold's documentation.

## Versions

An SDK `v0.X.y` is built for playhold `v0.X`, and works with any playhold `v0.X.*`. To use playhold 0.4.3, take the
latest 0.4.x SDK.

## Development

Needs Node, Go and network access: the wire code is generated from playhold's proto at the version in the `Makefile`,
and the tests run against `testserver/`, a small Go game server on that same version.

```bash
make check   # type-check and test, build the test server, and check testserver/go.mod requires the pinned version
make gen     # generate src/gen from playhold's proto at PLAYHOLD_VERSION
make tidy    # tidy the test server's module
```

To move to a new playhold version: change `PLAYHOLD_VERSION` in the `Makefile`, require the same version in
`testserver/go.mod`, then `make tidy gen check`.

## License

[Apache-2.0](LICENSE).