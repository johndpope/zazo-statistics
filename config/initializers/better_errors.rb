if defined? BetterErrors
  BetterErrors.editor = Figaro.env.better_errors_editor if Figaro.env.better_errors_editor?
end
