import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AppModule } from './app.module';

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  const port = configService.get<number>('APP_PORT', 3000);
  const nodeEnv = configService.get<string>('NODE_ENV', 'development');

  await app.listen(port);
  console.log(`✅ Application running on port ${port} (${nodeEnv})`);
}

bootstrap();
