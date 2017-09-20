// Copyright 2017 PingCAP, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"math/rand"
	"sync/atomic"
)

type Generator interface {
	NextID() uint64
	RandID() uint64
}

type UniformGenerator struct {
	maxID uint64
	r     *rand.Rand
}

func NewUniformGenerator(maxID uint64) *UniformGenerator {
	return &UniformGenerator{
		maxID: maxID,
		r:     NewSeekedRander(),
	}
}

func (g *UniformGenerator) NextID() uint64 {
	return atomic.AddUint64(&g.maxID, 1)
}

func (g *UniformGenerator) RandID() uint64 {
	maxID := atomic.LoadUint64(&g.maxID)
	return uint64(g.r.Int63n(int64(maxID + 1)))
}
