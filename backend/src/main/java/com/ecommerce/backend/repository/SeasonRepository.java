package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.Season;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SeasonRepository extends JpaRepository<Season, Long> {
}
