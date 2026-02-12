# Contributing to RailsMap

First off, thank you for considering contributing to RailsMap! 🎉

It's people like you that make RailsMap such a great tool for the Rails community.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Pull Request Process](#pull-request-process)
- [Style Guidelines](#style-guidelines)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the [issue tracker](https://github.com/ArshdeepGrover/rails-map/issues) as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples to demonstrate the steps**
- **Describe the behavior you observed and what behavior you expected**
- **Include screenshots if relevant**
- **Include your environment details:**
  - Rails version
  - Ruby version
  - RailsMap version
  - Operating system

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- **Use a clear and descriptive title**
- **Provide a detailed description of the suggested enhancement**
- **Explain why this enhancement would be useful**
- **List any similar features in other tools**

### Pull Requests

We actively welcome your pull requests:

1. Fork the repo and create your branch from `main`
2. If you've added code that should be tested, add tests
3. Ensure the test suite passes
4. Make sure your code follows the existing style
5. Write a clear commit message
6. Submit your pull request!

## Development Setup

1. **Fork and clone the repository**

   ```bash
   git clone https://github.com/YOUR_USERNAME/rails-map.git
   cd rails-map
   ```

2. **Install dependencies**

   ```bash
   bundle install
   ```

3. **Run tests**

   ```bash
   bundle exec rake spec
   ```

4. **Test locally in a Rails app**

   ```bash
   # In your gemfile
   gem 'rails_map', path: '/path/to/your/local/rails-map'

   # Then
   bundle install
   rails g rails_map:install
   rails server
   ```

## Pull Request Process

1. **Update documentation** - Update the README.md with details of changes if applicable
2. **Update CHANGELOG.md** - Add your changes under the "Unreleased" section
3. **Follow the style guidelines** - Ensure your code follows Ruby and Rails conventions
4. **Write tests** - Add tests for new features or bug fixes
5. **Keep commits clean** - Use clear, descriptive commit messages
6. **One feature per PR** - Keep pull requests focused on a single feature or fix

### Commit Message Guidelines

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

Examples:

```
Add parameter detection for nested routes

- Extract nested parameters from controller actions
- Add tests for nested parameter detection
- Update documentation

Fixes #123
```

## Style Guidelines

### Ruby Style Guide

- Follow the [Ruby Style Guide](https://rubystyle.guide/)
- Use 2 spaces for indentation (no tabs)
- Keep lines under 120 characters
- Use meaningful variable and method names
- Add comments for complex logic

### Code Organization

- Keep methods small and focused
- Follow Single Responsibility Principle
- Use descriptive names for classes and modules
- Organize code logically within files

### Testing

- Write tests for new features
- Ensure existing tests pass
- Aim for good test coverage
- Use descriptive test names

## Project Structure

```
rails-map/
├── app/                    # Rails engine views and controllers
│   ├── controllers/
│   ├── models/
│   └── views/
├── lib/                    # Core library code
│   ├── generators/         # Rails generators
│   ├── rails_map/
│   │   ├── parsers/       # Route and model parsers
│   │   └── generators/    # HTML generators
│   └── rails_map.rb
├── templates/              # HTML templates
├── spec/                   # Tests
└── docs/                   # Documentation
```

## Areas for Contribution

We especially welcome contributions in these areas:

### High Priority

- [ ] Additional parameter detection patterns
- [ ] Support for more Rails versions
- [ ] Performance improvements
- [ ] Better error handling
- [ ] More comprehensive tests

### Medium Priority

- [ ] Additional themes and customization options
- [ ] Export to different formats (JSON, Markdown, etc.)
- [ ] Integration with API documentation tools
- [ ] Internationalization (i18n)

### Nice to Have

- [ ] Interactive API testing
- [ ] Request/response examples
- [ ] API versioning support
- [ ] GraphQL support
- [ ] WebSocket documentation

## Questions?

Feel free to:

- Open an issue with the "question" label
- Reach out to the maintainers
- Check existing issues and discussions

## Recognition

Contributors will be recognized in:

- The CHANGELOG.md file
- GitHub contributors page
- Project documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to RailsMap! 🚀
