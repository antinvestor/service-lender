package business

import (
	"context"

	"github.com/pitabwire/frame/workerpool"
)

// workerpoolConsumeStream wraps workerpool.ConsumeResultStream for use in business methods.
func workerpoolConsumeStream[T any](
	ctx context.Context,
	pipe workerpool.JobResultPipe[[]T],
	consumer func(batch []T) error,
) error {
	return workerpool.ConsumeResultStream(ctx, pipe, func(res []T) error {
		return consumer(res)
	})
}
