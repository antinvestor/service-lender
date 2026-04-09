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

// versionedModel extends data.BaseModelI with a settable Version field.
type versionedModel interface {
	data.BaseModelI
	SetVersion(v uint)
}

// upsertVersioned is a generic helper that executes the common version-based
// upsert logic shared by all group event handlers, eliminating duplicated Execute() methods.
func upsertVersioned[T versionedModel](
	ctx context.Context,
	repo datastore.BaseRepository[T],
	entity T,
	eventName string,
) error {
	log := util.Log(ctx)

	if entity.GetVersion() > 0 {
		_, err := repo.Update(ctx, entity)
		if err != nil {
			log.WithError(err).Error(fmt.Sprintf("%s -- could not update", eventName))
			return err
		}
		return nil
	}

	err := repo.Create(ctx, entity)
	if err == nil {
		return nil
	}

	if !data.ErrorIsDuplicateKey(err) {
		log.WithError(err).Error(fmt.Sprintf("%s -- could not create", eventName))
		return err
	}

	log.WithError(err).Warn(fmt.Sprintf("%s -- duplicate, attempting update", eventName))
	return upsertOnDuplicate(ctx, repo, entity, eventName, log)
}

// upsertOnDuplicate handles the duplicate-key fallback path: loads the existing
// entity's version and retries as an update.
func upsertOnDuplicate[T versionedModel](
	ctx context.Context,
	repo datastore.BaseRepository[T],
	entity T,
	eventName string,
	log *util.LogEntry,
) error {
	existing, getErr := repo.GetByID(ctx, entity.GetID())
	if getErr != nil {
		return getErr
	}
	entity.SetVersion(existing.GetVersion())
	_, err := repo.Update(ctx, entity)
	if err != nil {
		log.WithError(err).Error(fmt.Sprintf("%s -- could not update existing", eventName))
		return err
	}
	return nil
}

// eventHandler is a generic event handler that implements events.EventI for any
// versioned model type, eliminating boilerplate duplication across individual event files.
type eventHandler[T versionedModel] struct {
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
	return upsertVersioned(ctx, e.repo, entity, e.name)
}

// upsertByID is a generic helper that executes an ID-based upsert for models
// that do not implement SetVersion (e.g. LoanWindow, LoanOffer).
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

// baseEventHandler is a generic event handler for models that use data.BaseModelI
// (without SetVersion), using upsertByID instead of upsertVersioned.
type baseEventHandler[T data.BaseModelI] struct {
	name     string
	factory  func() T
	validate func(context.Context, T) error
	repo     datastore.BaseRepository[T]
}

func (e *baseEventHandler[T]) Name() string {
	return e.name
}

func (e *baseEventHandler[T]) PayloadType() any {
	return e.factory()
}

func (e *baseEventHandler[T]) Validate(ctx context.Context, payload any) error {
	entity, ok := payload.(T)
	if !ok {
		return fmt.Errorf("invalid payload type for %s", e.name)
	}
	return e.validate(ctx, entity)
}

func (e *baseEventHandler[T]) Execute(ctx context.Context, payload any) error {
	entity, ok := payload.(T)
	if !ok {
		return fmt.Errorf("invalid payload type for %s", e.name)
	}
	return upsertByID(ctx, e.repo, entity, e.name)
}
