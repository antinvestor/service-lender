package events

import (
	"context"
	"errors"
	"fmt"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/util"
	"gorm.io/gorm"
)

// upsertByID is a generic helper that executes the common GetByID-based upsert
// logic shared by all operations event handlers, eliminating duplicated Execute() methods.
func upsertByID[T data.BaseModelI](
	ctx context.Context,
	repo datastore.BaseRepository[T],
	entity T,
	eventName string,
) error {
	log := util.Log(ctx)

	existing, err := repo.GetByID(ctx, entity.GetID())
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		log.WithError(err).Error(fmt.Sprintf("%s -- failed to check existing record", eventName))
		return err
	}

	if err == nil && existing.GetID() != "" {
		_, err = repo.Update(ctx, entity)
		if err != nil {
			log.WithError(err).Error(fmt.Sprintf("%s -- failed to update record", eventName))
			return err
		}
		return nil
	}

	err = repo.Create(ctx, entity)
	if err != nil {
		log.WithError(err).Error(fmt.Sprintf("%s -- failed to create record", eventName))
		return err
	}
	return nil
}

// eventHandler is a generic event handler that implements events.EventI for any
// model type, eliminating boilerplate duplication across individual event files.
type eventHandler[T data.BaseModelI] struct {
	name     string
	factory  func() T
	validate func(context.Context, T) error
	repo     datastore.BaseRepository[T]
}

func (e *eventHandler[T]) Name() string {
	return e.name
}

func (e *eventHandler[T]) PayloadType() any {
	return e.factory()
}

func (e *eventHandler[T]) Validate(ctx context.Context, payload any) error {
	entity, ok := payload.(T)
	if !ok {
		return fmt.Errorf("invalid payload type for %s", e.name)
	}
	return e.validate(ctx, entity)
}

func (e *eventHandler[T]) Execute(ctx context.Context, payload any) error {
	entity, ok := payload.(T)
	if !ok {
		return fmt.Errorf("invalid payload type for %s", e.name)
	}
	return upsertByID(ctx, e.repo, entity, e.name)
}
