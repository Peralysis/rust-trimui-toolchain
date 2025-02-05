<a id="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">

  <h3 align="center">Rust TrimUI Toolchain</h3>

  <p align="center">
    A toolchain image for cross-compiling to TrimUI devices using Rust's <a href="https://github.com/cross-rs/cross">cross</a>
    <br />
    <a href="https://github.com/Peralysis/rust-trimui-toolchain"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Peralysis/rust-trimui-toolchain/issues/new">Report Bug</a>
    &middot;
    <a href="https://github.com/Peralysis/rust-trimui-toolchain/issues/new">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

The toolchain image is designed to facilitate cross-compilation for TrimUI devices, leveraging Rust Cross to streamline the build process. It provides a pre-configured environment that includes the necessary compiler toolchains, libraries, and dependencies required for targeting TrimUI’s ARM-based architecture. This setup eliminates the need for manual toolchain configuration, ensuring a more seamless development experience. 

See more about cross-compiling with Rust here: https://github.com/cross-rs/cross.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started
Getting started cross-compiling you code is pretty easy! There's just a few one-time steps and then you're good to go.

### Prerequisites

#### Container Engine
You're going to need either Docker or Podman to build and use these toolchain image.

Install Docker: https://www.docker.com/get-started/
Install Podman: https://podman.io/get-started

Either work fine and the process is identical regardless of which container engine you choose. So pick the one you like most!

#### Rust Target
You're going to need to install the correct target that you want to compile for. In the case of the TrimUI, you need to target `aarch64-unknown-linux-gnu`.

```sh
rustup target add aarch64-unknown-linux-gnu
```

And that's it for that.

#### cross

You're also going to want to head over to the [cross](https://github.com/cross-rs/cross) GitHub page, and follow the instructions there to install: https://github.com/cross-rs/cross?tab=readme-ov-file#installation

```sh
cargo install cross --git https://github.com/cross-rs/cross
```

### Building
Once you have the prerequsuites, all you need to do is build the image. This isn't really any different than building any Docker image.

1. Clone this repo (or fork it and then clone it)
2. Build the image using `podman build -t trimui-toolchain .` or `docker build -t trimui-toolchain .`

You can also run the PowerShell script at the root of the project: `.\build.ps1`. By default, it will try to use podman. If you want to use Docker, just tell it using the `ContainerEngine` parameter: `.\build.ps1 -ContainerEngine docker`. The script doesn't do much, though, so no pressure.

Note: It doesn't really matter what you tag the image. Just make sure you remember it when you're configuring [cross](https://github.com/cross-rs/cross) for your project.

### Configuration

Once your toolchain image is build and [cross](https://github.com/cross-rs/cross) is installed, you just need to setup a Cross.toml file in your project.

```toml
[target.aarch64-unknown-linux-gnu]
image = "trimui-toolchain:latest"

[build.env]
passthrough = [
    "CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_RUSTFLAGS=-C link-args=--sysroot=/opt/aarch64-linux-gnu-7.5.0-linaro/sysroot -C link-args=-L/opt/aarch64-linux-gnu-7.5.0-linaro/sysroot/usr/lib -C link-args=-L/opt/SDL2-2.26.1 -C link-arg=-lSDL2"
]
```

This does two things:
1. Tells [cross](https://github.com/cross-rs/cross) that you want to use a custom image and which image to use
2. Tells [cross](https://github.com/cross-rs/cross) that you want to passthrough some environmnet variables. Specifically, the `CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_RUSTFLAGS` env var, which tells cargo what rustc flags to use. We're telling it where to find the sysroot and what libraries to link. You can add to these as you fit...but I wouldn't recommend removing any.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage

Alright, time for the fun part. With the image built, [cross](https://github.com/cross-rs/cross) installed and configured, all you need to do is compile!

This looks like a typical cargo build command. Remember earlier when you added the `aarch64-unknown-linux-gnu` target using rustup? No? Go back and do first. But if you do remmeber, this is where we're going to target that.

```sh
cross build --target aarch64-unknown-linux-gnu
```

And that's all there is to it! You're TrimUI ready executable is ready to be dropped on your device. Don't ask me how to do that, though. It various per firmware you're using. You can find plenty of examples. Just look in your SD card in the Apps or Tools folder for some examples.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

Inspired and mostly stolen by some cool nerd called [s0ckz](https://github.com/s0ckz/trimui-smart-pro-toolchain). Thanks for the hard work!

<p align="right">(<a href="#readme-top">back to top</a>)</p>