package logger

import (
	"fmt"
	"log/slog"
	"os"
)

type Logger struct {
	base *slog.Logger
}

func New() *Logger {
	return &Logger{
		base: slog.New(
			NewHandler(os.Stdout),
		),
	}
}

func (l *Logger) Info(message string, args ...any) {
	l.base.Info(fmt.Sprintf(message, args...))
}

func (l *Logger) Step(message string, args ...any) {
	l.base.Info(fmt.Sprintf("→ "+message, args...))
}

func (l *Logger) Success(message string, args ...any) {
	l.base.Info(fmt.Sprintf("✓ "+message, args...))
}

func (l *Logger) Warn(message string, args ...any) {
	l.base.Warn(fmt.Sprintf("⚠ "+message, args...))
}

func (l *Logger) Error(message string, args ...any) {
	l.base.Error(fmt.Sprintf("✗ "+message, args...))
}
