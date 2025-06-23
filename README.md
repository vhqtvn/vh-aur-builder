# AUR Package Builder

This repository contains a Docker-based AUR package builder with GitHub Actions integration for automated builds and releases.

## Features

- **Docker-based build environment** using Arch Linux
- **GitHub Actions workflow** for automated package building
- **Local Docker builds** - no registry pushing required
- **Artifact storage** for built packages
- **Automatic GitHub releases** with package uploads
- **Runs on every commit** to main/master branch
- **Manual trigger option** for custom builds
- **Default package**: `rocblas-gfx1103`
- **Optimized for AMD GPU builds** with specific environment variables

## Docker Environment

The Dockerfile sets up a clean Arch Linux environment with:
- `base-devel` group for building packages
- `git`, `debugedit`, `fakeroot`, `binutils` for package creation
- `ccache` for faster rebuilds
- `sudo` access for the `builder` user

## Build Environment Variables

For the `rocblas-gfx1103` package build, the following environment variables are set:

- `HSA_OVERRIDE_GFX_VERSION=11.0.2` - Specifies the HSA GFX version
- `HCC_AMDGPU_TARGETS=gfx1102` - Specifies the AMD GPU target architecture

These variables are passed to the Docker container during the build process to ensure proper compilation for AMD GPU architectures.

## GitHub Actions Workflow

### Triggers

The workflow can be triggered in three ways:

1. **Push to main/master**: Runs automatically on every commit to main or master branch
2. **Pull requests**: Runs on PRs to main or master branch (builds but doesn't create releases)
3. **Manual trigger**: Use the workflow dispatch with custom package name and version

### Workflow Steps

1. **Build Package Job**:
   - Builds the Docker image locally from the repository's Dockerfile
   - Clones the specified AUR package (defaults to `rocblas-gfx1103`)
   - Builds the package using `makepkg` with AMD GPU environment variables
   - Uploads package artifacts (`*.pkg.*` files)

2. **Create Release Job** (only for pushes to main/master and manual triggers):
   - Downloads all artifacts from the build job
   - Creates a GitHub release with package information
   - Uploads package files as release assets

## Usage

### Method 1: Automatic Builds (Every Commit)

Simply push to your main or master branch:

```bash
git add .
git commit -m "Update build configuration"
git push origin main
```

The workflow will automatically:
- Build the `rocblas-gfx1103` package with AMD GPU optimizations
- Generate a version based on date and commit hash (e.g., `20241201-a1b2c3d`)
- Create a prerelease with the built package

### Method 2: Manual Build

1. Go to the **Actions** tab in your GitHub repository
2. Select **Build AUR Package and Create Release**
3. Click **Run workflow**
4. Enter the package name (defaults to `rocblas-gfx1103`) and version
5. Click **Run workflow**

## Version Naming

- **Automatic builds**: `YYYYMMDD-<commit-hash>` (e.g., `20241201-a1b2c3d`)
- **Manual builds**: Use the version you specify in the workflow dispatch
- **Pull requests**: Builds but doesn't create releases

## Output

The workflow produces:

1. **GitHub Artifacts**: Package files stored for 30 days
2. **GitHub Release**: With package files attached as assets (prerelease for automatic builds)
3. **Local Docker Image**: Built fresh for each run

## Package Installation

After the workflow completes, you can install the built package:

```bash
# Download the package from the GitHub release
wget https://github.com/your-username/your-repo/releases/download/<commit-hash>/rocblas-gfx1103-20241201-a1b2c3d.pkg.tar.zst

# Install the package
sudo pacman -U rocblas-gfx1103-20241201-a1b2c3d.pkg.tar.zst
```

## Requirements

- GitHub repository with Actions enabled
- `GITHUB_TOKEN` secret (automatically available)
- Write permissions to create releases

## Customization

### Modify Build Environment

Edit the `Dockerfile` to add additional packages or tools needed for building specific packages.

### Workflow Customization

The workflow can be customized by modifying `.github/workflows/build-aur-package.yml`:

- Add additional build steps
- Modify artifact retention period
- Change release naming conventions
- Add package verification steps
- Change the default package
- Modify which branches trigger the workflow
- Update environment variables for different GPU architectures

## Troubleshooting

### Common Issues

1. **Package build fails**: Check if the AUR package has all required dependencies
2. **Docker build fails**: Ensure the Dockerfile is valid and all packages are available
3. **Release creation fails**: Verify the repository has release permissions
4. **GPU compilation issues**: Verify the environment variables are set correctly for your target architecture

### Debugging

- Check the Actions logs for detailed error messages
- Verify the package name and version format
- Ensure the AUR package exists and is accessible
- Check that the AMD GPU environment variables are appropriate for your build

## License

This project is open source. Feel free to modify and distribute according to your needs. 