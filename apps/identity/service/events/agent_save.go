package events

import (
	"context"
	"errors"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
	"github.com/pitabwire/util"
)

const AgentSaveEvent = "agent.save"

type AgentSave struct {
	agentRepo repository.AgentRepository
}

func NewAgentSave(_ context.Context, agentRepo repository.AgentRepository) *AgentSave {
	return &AgentSave{agentRepo: agentRepo}
}

func (e *AgentSave) Name() string         { return AgentSaveEvent }
func (e *AgentSave) PayloadType() any     { return &models.Agent{} }

func (e *AgentSave) Validate(_ context.Context, payload any) error {
	agent, ok := payload.(*models.Agent)
	if !ok {
		return errors.New("payload is not of type models.Agent")
	}
	if agent.GetID() == "" {
		return errors.New("agent ID should already have been set")
	}
	return nil
}

func (e *AgentSave) Execute(ctx context.Context, payload any) error {
	agent := payload.(*models.Agent)

	logger := util.Log(ctx).WithField("type", e.Name()).WithField("agent_id", agent.GetID())
	defer logger.Release()
	logger.Debug("event handler started")

	err := e.agentRepo.Create(ctx, agent)
	if err != nil {
		logger.WithError(err).Error("could not save agent to db")
		return err
	}

	logger.Debug("event handler completed successfully")
	return nil
}
