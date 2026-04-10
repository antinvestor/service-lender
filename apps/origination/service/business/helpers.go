package business

import (
	"context"
	"strconv"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/frame/workerpool"
	"github.com/pitabwire/util"
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

func buildSearchOptions(cursor *commonv1.PageCursor, andFilters map[string]any, query string) []data.SearchOption {
	var searchOpts []data.SearchOption

	if cursor != nil {
		offset, offsetErr := strconv.Atoi(cursor.GetPage())
		if offsetErr != nil {
			offset = 0
		}
		searchOpts = append(searchOpts, data.WithSearchOffset(offset), data.WithSearchLimit(int(cursor.GetLimit())))
	}

	if len(andFilters) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andFilters))
	}

	if query != "" {
		searchOpts = append(searchOpts,
			data.WithSearchFiltersOrByValue(
				map[string]any{"searchable @@ websearch_to_tsquery( 'english', ?) ": query},
			),
		)
	}

	return searchOpts
}

func consumeAPISearchResults[T any, A any](
	ctx context.Context,
	results workerpool.JobResultPipe[[]T],
	toAPI func(T) *A,
	consumer func(ctx context.Context, batch []*A) error,
) error {
	return workerpoolConsumeStream(ctx, results, func(res []T) error {
		apiResults := make([]*A, 0, len(res))
		for _, item := range res {
			apiResults = append(apiResults, toAPI(item))
		}
		return consumer(ctx, apiResults)
	})
}

func executeSearch[T any, A any](
	ctx context.Context,
	logger *util.LogEntry,
	searchFn func(context.Context, *data.SearchQuery) (workerpool.JobResultPipe[[]T], error),
	cursor *commonv1.PageCursor,
	andFilters map[string]any,
	queryText string,
	errMessage string,
	toAPI func(T) *A,
	consumer func(ctx context.Context, batch []*A) error,
) error {
	searchOpts := buildSearchOptions(cursor, andFilters, queryText)
	results, err := searchFn(ctx, data.NewSearchQuery(searchOpts...))
	if err != nil {
		logger.WithError(err).Error(errMessage)
		return err
	}

	return consumeAPISearchResults(ctx, results, toAPI, consumer)
}
