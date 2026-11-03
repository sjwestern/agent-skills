# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- Fixed 'check-test-results' skill examples calling a non-existent `check-test-results` command. They now run `run.sh` from the skill directory.
- Moved `caveman` to `skills/` and stopped tracking `.agents/skills/` to avoid duplicate skill discovery.
- Added root MIT `LICENSE`, restored the upstream `LICENSE` for `commit`, and documented skill sources in the README.

## [0.0.2] - 2026-07-16

- Added 'check-test-results' skill.
- Removed atomic commits skill in favour of newer commit skill from helderberto/agent-skills.
- Changed `commit` skill to the latest version from helderberto/agent-skills (f55869b).
- Fixed layout, moved published skills to ./skills directory

## [0.0.1] - 2026-07-16

- Added copy of the commit skill from helderberto/agent-skills.
- Added copy of the caveman skill from mattpocock/skills (now removed in his repo).
