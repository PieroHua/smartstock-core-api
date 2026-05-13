import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HealthModule } from './modules/health/health.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => {
        const host = configService.get<string>('DATABASE_HOST', 'localhost');
        const isRemote = host !== 'localhost' && host !== '127.0.0.1';
        
        return {
          type: 'postgres',
          host,
          port: configService.get<number>('DATABASE_PORT', 5432),
          username: configService.get<string>('DATABASE_USER', 'postgres'),
          password: configService.get<string>('DATABASE_PASSWORD', 'postgres'),
          database: configService.get<string>('DATABASE_NAME', 'smartstock'),
          entities: ['dist/**/*.entity{.ts,.js}'],
          migrations: ['dist/database/migrations/*{.ts,.js}'],
          migrationsRun: false,
          synchronize: process.env.NODE_ENV === 'development',
          logging: process.env.NODE_ENV === 'development',
          ssl: isRemote ? { rejectUnauthorized: false } : false,
        };
      },
    }),
    HealthModule,
  ],
})
export class AppModule {}
