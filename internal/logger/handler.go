package logger

import (
	"context"
	"fmt"
	"io"
	"log/slog"
)

type Handler struct {
	writer io.Writer
}

func NewHandler(writer io.Writer) *Handler {
	return &Handler{
		writer: writer,
	}
}

func (h *Handler) Enabled(
	_ context.Context,
	_ slog.Level,
) bool {
	return true
}

func (h *Handler) Handle(
	_ context.Context,
	record slog.Record,
) error {

	_, err := fmt.Fprintf(
		h.writer,
		"%s\n",
		record.Message,
	)

	return err
}

func (h *Handler) WithAttrs(_ []slog.Attr) slog.Handler {
	return h
}

func (h *Handler) WithGroup(_ string) slog.Handler {
	return h
}
