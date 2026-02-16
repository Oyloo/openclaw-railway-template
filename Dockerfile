# Build openclaw from source to avoid npm packaging gaps (some dist files are not shipped).
FROM node:22-bookworm AS openclaw-build

# Dependencies needed for openclaw build
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    curl \
    python3 \
    make \
    g++ \
  && rm -rf /var/lib/apt/lists/*

# Install Bun (openclaw build uses it)
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

RUN corepack enable

WORKDIR /openclaw

# Pin to a known ref (tag/branch). If it doesn't exist, fall back to main.
ARG OPENCLAW_GIT_REF=main
RUN git clone --depth 1 --branch "${OPENCLAW_GIT_REF}" https://github.com/openclaw/openclaw.git .

# Patch: relax version requirements for packages that may reference unpublished versions.
# Apply to all extension package.json files to handle workspace protocol (workspace:*).
RUN set -eux; \
  find ./extensions -name 'package.json' -type f | while read -r f; do \
    sed -i -E 's/"openclaw"[[:space:]]*:[[:space:]]*">=[^"]+"/"openclaw": "*"/g' "$f"; \
    sed -i -E 's/"openclaw"[[:space:]]*:[[:space:]]*"workspace:[^"]+"/"openclaw": "*"/g' "$f"; \
  done

RUN pnpm install --no-frozen-lockfile
RUN pnpm build
ENV OPENCLAW_PREFER_PNPM=1
RUN pnpm ui:install && pnpm ui:build


# Runtime image
FROM node:22-bookworm
ENV NODE_ENV=production

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    build-essential \
    gcc \
    g++ \
    make \
    procps \
    file \
    git \
    python3 \
    pkg-config \
    sudo \
    jq \
    ripgrep \
    tmux \
    neovim \
    gh \
    ffmpeg \
  && rm -rf /var/lib/apt/lists/*

# Install Homebrew (must run as non-root user)
# Create a user for Homebrew installation, install it, then make it accessible to all users
RUN useradd -m -s /bin/bash linuxbrew \
  && echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER linuxbrew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Install Linux skill CLIs that must persist across redeploys
RUN HOMEBREW_NO_AUTO_UPDATE=1 /home/linuxbrew/.linuxbrew/bin/brew install \
    himalaya \
    nushell

# Linux/x86_64 subset from steipete tap.
# Excluded as arm64-macOS only: blucli, camsnap, mcporter, sonoscli.
RUN /home/linuxbrew/.linuxbrew/bin/brew tap steipete/tap \
  && for pkg in \
    steipete/tap/codexbar \
    steipete/tap/gifgrep \
    steipete/tap/gogcli \
    steipete/tap/goplaces \
    steipete/tap/oracle \
    steipete/tap/ordercli \
    steipete/tap/sag \
    steipete/tap/songsee \
    steipete/tap/spogo \
    steipete/tap/wacli; do \
      HOMEBREW_NO_AUTO_UPDATE=1 /home/linuxbrew/.linuxbrew/bin/brew install "$pkg"; \
    done \
  && HOMEBREW_NO_AUTO_UPDATE=1 /home/linuxbrew/.linuxbrew/bin/brew tap openhue/cli \
  && HOMEBREW_NO_AUTO_UPDATE=1 /home/linuxbrew/.linuxbrew/bin/brew install openhue/cli/openhue-cli

USER root
RUN chown -R root:root /home/linuxbrew/.linuxbrew
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

# JS CLIs
RUN npm install -g @steipete/bird @steipete/summarize clawhub @google/gemini-cli @railway/cli

# uv (Astral) + compatibility alias for spotify-player skill check
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
  && mv /root/.local/bin/uv /usr/local/bin/uv \
  && if command -v spogo >/dev/null 2>&1; then ln -sf "$(command -v spogo)" /usr/local/bin/spotify_player; fi

WORKDIR /app

# Wrapper deps
RUN corepack enable
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --prod --frozen-lockfile && pnpm store prune

# Copy built openclaw
COPY --from=openclaw-build /openclaw /openclaw

# Provide a openclaw executable
RUN printf '%s\n' '#!/usr/bin/env bash' 'exec node /openclaw/dist/entry.js "$@"' > /usr/local/bin/openclaw \
  && chmod +x /usr/local/bin/openclaw

COPY src ./src

ENV PORT=8080
EXPOSE 8080
CMD ["node", "src/server.js"]
