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
)

type OP int

const (
	NOOP OP = iota
	InsertOP
	SelectOP
)

type Workload struct {
	InsertRatio float32 `toml:"insert-ratio"`
	SelectRatio float32 `toml:"select-ratio"`
}

type WorkloadRander struct {
	ratios []float32
}

func NewWorkloadRander(w Workload) *WorkloadRander {
	return &WorkloadRander{
		ratios: []float32{
			0.0,
			w.InsertRatio,
			w.SelectRatio,
		},
	}
}

func (w *WorkloadRander) RandomOP(r *rand.Rand) OP {
	p := r.Float32()
	for op, ratio := range w.ratios {
		if p < ratio {
			return OP(op)
		}
		p -= ratio
	}
	return NOOP
}
